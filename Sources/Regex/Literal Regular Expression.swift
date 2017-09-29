// PatternKit © 2017 Constantino Tsarouhas

import DepthKit
import PatternKitBundle

/// A regular expression that expresses a literal pattern.
public struct LiteralRegularExpression {
	
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
	
	/// A symbol that represents a literal character.
	public struct Symbol {
		
		/// The character represented by the symbol.
		var character: Character
		
	}
	
}

extension LiteralRegularExpression : RegularExpression {
	
	public typealias Index = String.Index
	
	public var startIndex: Index {
		return literal.startIndex
	}
	
	public var endIndex: Index {
		return literal.endIndex
	}
	
	public subscript (index: Index) -> Symbol {
		return Symbol(character: literal[index])
	}
	
	public func index(before index: Index) -> Index {
		return literal.index(before: index)
	}
	
	public func index(after index: Index) -> Index {
		return literal.index(after: index)
	}
	
}

extension LiteralRegularExpression.Symbol : Symbol {
	
	public func serialisation(language: Language) -> String {
		TODO.unimplemented
	}
	
}
