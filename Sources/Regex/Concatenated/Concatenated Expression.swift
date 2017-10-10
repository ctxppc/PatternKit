// PatternKit © 2017 Constantino Tsarouhas

import DepthKit

/// An expression that concatenates two subexpressions.
public struct ConcatenatedExpression<LeadingExpression : Expression, TrailingExpression : Expression> where
	LeadingExpression.Indices : BidirectionalCollection,
	TrailingExpression.Indices : BidirectionalCollection {
	
	/// Creates a concatenated expression with given subexpressions.
	///
	/// - Parameter leadingExpression: The expression that forms the first part of the concatenated expression.
	/// - Parameter trailingExpression: The expression that follows the leading expression.
	public init(_ leadingExpression: LeadingExpression, _ trailingExpression: TrailingExpression) {
		self.leadingExpression = leadingExpression
		self.trailingExpression = trailingExpression
	}
	
	/// The expression that forms the first part of the concatenated expression.
	public var leadingExpression: LeadingExpression
	
	/// The expression that follows the leading expression.
	public var trailingExpression: TrailingExpression
	
}

extension ConcatenatedExpression : Expression {
	
	public enum Index {
		
		/// A position of a symbol in the leading expression.
		///
		/// - Invariant: `innerIndex` is an index to a symbol in the leading expression.
		///
		/// - Parameter innerIndex: The position of the symbol within the leading expression.
		case inLeadingExpression(innerIndex: LeadingExpression.Index)
		
		/// A position of a symbol in the trailing expression.
		///
		/// - Invariant: `innerIndex` is an index to a symbol in the trailing expression.
		///
		/// - Parameter innerIndex: The position of the symbol within the trailing expression.
		case inTrailingExpression(innerIndex: TrailingExpression.Index)
		
		/// The position after the last symbol.
		case end
		
	}
	
	public var startIndex: Index {
		if let firstIndex = leadingExpression.indices.first {
			return .inLeadingExpression(innerIndex: firstIndex)
		} else if let firstIndex = trailingExpression.indices.first {
			return .inTrailingExpression(innerIndex: firstIndex)
		} else {
			return .end
		}
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> SymbolProtocol {
		switch index {
			case .inLeadingExpression(innerIndex: let index):	return leadingExpression[index]
			case .inTrailingExpression(innerIndex: let index):	return trailingExpression[index]
			case .end:											indexOutOfBounds
		}
	}
	
	public func index(before index: Index) -> Index {
		switch index {
			
			case .inLeadingExpression(innerIndex: let index):
			return .inLeadingExpression(innerIndex: leadingExpression.index(before: index))
			
			case .inTrailingExpression(innerIndex: let index) where index == trailingExpression.startIndex:
			guard let lastIndex = leadingExpression.indices.last else { indexOutOfBounds }
			return .inLeadingExpression(innerIndex: lastIndex)
			
			case .inTrailingExpression(innerIndex: let index):
			return .inTrailingExpression(innerIndex: trailingExpression.index(before: index))
			
			case .end:
			if let lastIndex = trailingExpression.indices.last {
				return .inTrailingExpression(innerIndex: lastIndex)
			} else if let lastIndex = leadingExpression.indices.last {
				return .inLeadingExpression(innerIndex: lastIndex)
			} else {
				indexOutOfBounds
			}
			
		}
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			
			case .inLeadingExpression(innerIndex: let index):
			let nextIndex = leadingExpression.index(after: index)
			if nextIndex < leadingExpression.endIndex {
				return .inLeadingExpression(innerIndex: nextIndex)
			} else if let firstIndex = trailingExpression.indices.first {
				return .inTrailingExpression(innerIndex: firstIndex)
			} else {
				return .end
			}
			
			case .inTrailingExpression(innerIndex: let index):
			let nextIndex = trailingExpression.index(after: index)
			guard nextIndex < trailingExpression.endIndex else { return .end }
			return .inTrailingExpression(innerIndex: nextIndex)
			
			case .end:
			indexOutOfBounds
			
		}
	}
	
	public var bindingClass: BindingClass {
		return .concatenation
	}
	
}

extension ConcatenatedExpression.Index : Comparable {
	
	public static func <(smallerIndex: ConcatenatedExpression.Index, greaterIndex: ConcatenatedExpression.Index) -> Bool {
		switch (smallerIndex, greaterIndex) {
			case (.inLeadingExpression(innerIndex: let smallerIndex), .inLeadingExpression(innerIndex: let greaterIndex)):		return smallerIndex < greaterIndex
			case (.inLeadingExpression, _):																						return true
			case (.inTrailingExpression, .inLeadingExpression):																	return false
			case (.inTrailingExpression(innerIndex: let smallerIndex), .inTrailingExpression(innerIndex: let greaterIndex)):	return smallerIndex < greaterIndex
			case (.inTrailingExpression, .end):																					return true
			case (.end, _):																										return false
		}
	}
	
	public static func ==(firstIndex: ConcatenatedExpression.Index, otherIndex: ConcatenatedExpression.Index) -> Bool {
		switch (firstIndex, otherIndex) {
			case (.inLeadingExpression(innerIndex: let firstIndex), .inLeadingExpression(innerIndex: let otherIndex)):		return firstIndex == otherIndex
			case (.inTrailingExpression(innerIndex: let firstIndex), .inTrailingExpression(innerIndex: let otherIndex)):	return firstIndex == otherIndex
			case (.end, .end):																								return true
			default:																										return false
		}
	}
	
}
