// PatternKit © 2017 Constantino Tsarouhas

import DepthKit
import PatternKitBundle

/// A regular expression with arbitrary literal symbols that expresses no pattern.
public struct CommentRegularExpression {
	
	/// The comment or unevaluated serialisation.
	public var comment: String
	
}

extension CommentRegularExpression : RegularExpression {
	
	public enum Index {
		
		/// The position of the leading boundary symbol.
		case leadingBoundary
		
		/// The position of a symbol that represents a character in the comment.
		///
		/// - Invariant: `index` is a valid, subscriptable index of the comment.
		///
		/// - Parameter index: The position of the represented character in the comment.
		case comment(index: String.Index)
		
		/// The position of the trailing boundary symbol.
		case trailingBoundary
		
		/// The position after the last symbol.
		case end
		
	}
	
	public var startIndex: Index {
		return .leadingBoundary
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> Symbol {
		TODO.unimplemented
	}
	
	public func index(before index: Index) -> Index {
		switch index {
			
			case .leadingBoundary:
			indexOutOfBounds
			
			case .comment(index: let index) where index == comment.startIndex:
			return .leadingBoundary
			
			case .comment(index: let index):
			return .comment(index: comment.index(before: index))
			
			case .trailingBoundary:
			guard let lastCharacterIndex = comment.indices.last else { return .leadingBoundary }
			return .comment(index: lastCharacterIndex)
			
			case .end:
			return .trailingBoundary
			
		}
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			
			case .leadingBoundary:
			guard let firstCharacterIndex = comment.indices.first else { return .trailingBoundary }
			return .comment(index: firstCharacterIndex)
			
			case .comment(index: let index):
			let nextCharacterIndex = comment.index(after: index)
			guard nextCharacterIndex < comment.endIndex else { return .trailingBoundary }
			return .comment(index: nextCharacterIndex)
			
			case .trailingBoundary:
			return .end
			
			case .end:
			indexOutOfBounds
			
		}
	}
	
}

extension CommentRegularExpression.Index : Comparable {
	
	public static func <(smallerIndex: CommentRegularExpression.Index, greaterIndex: CommentRegularExpression.Index) -> Bool {
		switch (smallerIndex, greaterIndex) {
			case (.leadingBoundary, .leadingBoundary):										return false
			case (.leadingBoundary, _):														return true
			case (.comment, .leadingBoundary):												return false
			case (.comment(index: let smallerIndex), .comment(index: let greaterIndex)):	return smallerIndex < greaterIndex
			case (.comment, _):																return true
			case (.trailingBoundary, .end):													return true
			case (.trailingBoundary, _):													return false
			case (.end, _):																	return false
		}
	}
	
	public static func ==(firstIndex: CommentRegularExpression.Index, otherIndex: CommentRegularExpression.Index) -> Bool {
		switch (firstIndex, otherIndex) {
			case (.leadingBoundary, .leadingBoundary):									return true
			case (.comment(index: let firstIndex), .comment(index: let otherIndex)):	return firstIndex == otherIndex
			case (.trailingBoundary, .trailingBoundary):								return true
			case (.end, .end):															return true
			default:																	return false
		}
	}
	
}
