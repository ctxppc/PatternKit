// PatternKit © 2017–21 Constantino Tsarouhas

import DepthKit

/// An expression with arbitrary literal symbols that expresses no pattern.
public struct CommentRegularExpression {
	
	/// Creates an expression with given arbitrary characters that expresses no pattern.
	///
	/// - Parameter comment: The comment or unevaluated serialisation.
	public init(_ comment: String) {
		self.comment = comment
	}
	
	/// The comment or unevaluated serialisation.
	public var comment: String
	
	public enum Symbol {
		
		/// A symbol that represents the leading boundary of a comment.
		case leadingBoundary
		
		/// A symbol that represents an unevaluated character in a comment.
		///
		/// - Parameter 1: The unevaluated character.
		case unevaluatedCharacter(Character)
		
		/// A symbol that represents the trailing boundary of a comment.
		case trailingBoundary
		
	}
	
}

extension CommentRegularExpression : Expression {
	
	public enum Index : Equatable {
		
		/// The position of the leading boundary symbol.
		case leadingBoundary
		
		/// A position of a symbol that represents a character in the comment.
		///
		/// - Invariant: `index` is an index to a character in the comment.
		///
		/// - Parameter index: The position of the represented character in the comment.
		case unevaluatedCharacter(index: String.Index)
		
		/// The position of the trailing boundary symbol.
		case trailingBoundary
		
		/// The position after the last symbol.
		case end
		
	}
	
	public var startIndex: Index { .leadingBoundary }
	
	public var endIndex: Index { .end }
	
	public subscript (index: Index) -> SymbolProtocol {
		switch index {
			case .leadingBoundary:							return Symbol.leadingBoundary
			case .unevaluatedCharacter(index: let index):	return Symbol.unevaluatedCharacter(comment[index])
			case .trailingBoundary:							return Symbol.trailingBoundary
			case .end:										indexOutOfBounds
		}
	}
	
	public func index(before index: Index) -> Index {
		switch index {
			
			case .leadingBoundary:
			indexOutOfBounds
			
			case .unevaluatedCharacter(index: let index) where index == comment.startIndex:
			return .leadingBoundary
			
			case .unevaluatedCharacter(index: let index):
			return .unevaluatedCharacter(index: comment.index(before: index))
			
			case .trailingBoundary:
			guard let lastCharacterIndex = comment.indices.last else { return .leadingBoundary }
			return .unevaluatedCharacter(index: lastCharacterIndex)
			
			case .end:
			return .trailingBoundary
			
		}
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			
			case .leadingBoundary:
			guard let firstCharacterIndex = comment.indices.first else { return .trailingBoundary }
			return .unevaluatedCharacter(index: firstCharacterIndex)
			
			case .unevaluatedCharacter(index: let index):
			let nextCharacterIndex = comment.index(after: index)
			guard nextCharacterIndex < comment.endIndex else { return .trailingBoundary }
			return .unevaluatedCharacter(index: nextCharacterIndex)
			
			case .trailingBoundary:
			return .end
			
			case .end:
			indexOutOfBounds
			
		}
	}
	
	public var bindingClass: BindingClass { .atomic }
	
}

extension CommentRegularExpression.Symbol : SymbolProtocol {
	
	public func serialisation(language: Language) throws -> String {
		guard language == .perlCompatibleREs else { throw SymbolSerialisationError.unsupportedByLanguage }
		switch self {
			case .leadingBoundary:						return "(?#"
			case .unevaluatedCharacter(")"):			throw SymbolSerialisationError.unsupportedByLanguage
			case .unevaluatedCharacter(let character):	return String(character)
			case .trailingBoundary:						return ")"
		}
	}
	
}

extension CommentRegularExpression.Index : Comparable {
	public static func <(smallerIndex: Self, greaterIndex: Self) -> Bool {
		switch (smallerIndex, greaterIndex) {
			case (.leadingBoundary, .leadingBoundary):																return false
			case (.leadingBoundary, _):																				return true
			case (.unevaluatedCharacter, .leadingBoundary):															return false
			case (.unevaluatedCharacter(index: let smallerIndex), .unevaluatedCharacter(index: let greaterIndex)):	return smallerIndex < greaterIndex
			case (.unevaluatedCharacter, _):																		return true
			case (.trailingBoundary, .end):																			return true
			case (.trailingBoundary, _):																			return false
			case (.end, _):																							return false
		}
	}
}
