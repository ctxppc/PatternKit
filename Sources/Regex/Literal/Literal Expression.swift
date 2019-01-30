// PatternKit © 2017–19 Constantino Tsarouhas

import DepthKit
import struct Foundation.CharacterSet

/// An expression that expresses a literal pattern.
public struct LiteralExpression {
	
	/// Creates a pattern that matches an exact string.
	///
	/// - Requires: `literal` is non-empty.
	///
	/// - Parameter literal: The string that the pattern matches exactly.
	public init(_ literal: String) {
		precondition(!literal.isEmpty, "Empty literal")
		self.literal = literal
	}
	
	/// The string that the pattern matches exactly.
	///
	/// - Invariant: `literal` is non-empty.
	public var literal: String {
		willSet {
			precondition(!newValue.isEmpty, "Empty literal")
		}
	}
	
	/// A symbol that represents a literal character in a literal expression.
	public struct Symbol {
		
		/// The character represented by the symbol.
		var character: Character
		
	}
	
}

extension LiteralExpression : Expression {
	
	public typealias Index = String.Index
	
	public var startIndex: Index {
		return literal.startIndex
	}
	
	public var endIndex: Index {
		return literal.endIndex
	}
	
	public subscript (index: Index) -> SymbolProtocol {
		return Symbol(character: literal[index])
	}
	
	public func index(before index: Index) -> Index {
		return literal.index(before: index)
	}
	
	public func index(after index: Index) -> Index {
		return literal.index(after: index)
	}
	
	public var bindingClass: BindingClass {
		return .concatenation
	}
	
}

extension LiteralExpression.Symbol : SymbolProtocol {
	
	public func serialisation(language: Language) -> String {
		
		let metacharacters: Set<Character> = ["[", "\\", "^", "$", ".", "|", "?", "*", "+", "(", ")", "{"]
		guard !metacharacters.contains(character) else { return "\\\(character)" }
		
		let unicodeScalars = character.unicodeScalars
		guard let scalar = unicodeScalars.first, unicodeScalars.count == 1 else { return String(character) }
		
		return serialiseGeneralScalar(scalar, language: language)
		
	}
	
}

/// Serialises given Unicode scalar in given language, escaping it if required in all contexts.
///
/// This function does not escape metacharacters (e.g., backslash) as they have lexical meaning dependent on context.
///
/// - Parameter scalar: The Unicode scalar to serialise.
/// - Parameter language: The language in which to serialise the scalar.
internal func serialiseGeneralScalar(_ scalar: UnicodeScalar, language: Language) -> String {
	
	guard CharacterSet.controlCharacters.contains(scalar) else { return String(scalar) }
	
	switch (scalar, language) {
		case ("\n", _):							return "\\n"
		case ("\r", _):							return "\\r"
		case ("\t", _):							return "\\t"
		case ("\u{7}", .perlCompatibleREs):		return "\\a"
		case ("\u{1A}", .perlCompatibleREs):	return "\\e"
		case ("\u{0C}", _):						return "\\f"
		case ("\u{0B}", .ecmaScript):			return "\\v"
		default:								break
	}
	
	let unpaddedScalarValue = String(scalar.value, radix: 16, uppercase: true)
	let paddingLength = 4 - unpaddedScalarValue.count
	let paddedScalarValue = paddingLength > 0
		? String(repeating: "0", count: paddingLength) + unpaddedScalarValue
		: unpaddedScalarValue
	
	switch language {
		case .perlCompatibleREs:	return "\\o{\(paddedScalarValue)}"
		case .ecmaScript:			return "\\u\(paddedScalarValue)"
	}
	
}
