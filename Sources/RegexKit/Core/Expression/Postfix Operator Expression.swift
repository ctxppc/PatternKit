// PatternKit © 2017–21 Constantino Tsarouhas

import DepthKit

/// A unary expression that is a sequence consisting of an optional leading boundary symbol, the subexpression's symbols, an optional trailing boundary symbol, and a postfix operator symbol.
///
/// The boundary symbols are added if the subexpression is of a lower binding class than the unary expression.
public protocol PostfixOperatorExpression : UnaryExpression {
	
	/// The symbol leading the subexpression.
	static var leadingBoundarySymbol: SymbolProtocol { get }
	
	/// The symbol trailing the subexpression.
	static var trailingBoundarySymbol: SymbolProtocol { get }
	
	/// The symbol that represents the postfix operator.
	var postfixOperatorSymbol: SymbolProtocol { get }
	
}

extension PostfixOperatorExpression where Index == PostfixOperatorExpressionIndex<Subexpression> {
	
	public var startIndex: Index {
		
		if groupsSubexpression {
			return .leadingBoundary
		}
		
		return .inSubexpression(innerIndex: subexpression.startIndex)	// Empty subexpressions are grouped
		
	}
	
	public var endIndex: Index { .end }
	
	public subscript (index: Index) -> SymbolProtocol {
		switch index {
			case .leadingBoundary:							return Self.leadingBoundarySymbol
			case .inSubexpression(innerIndex: let index):	return subexpression[index]
			case .trailingBoundary:							return Self.trailingBoundarySymbol
			case .postfixOperator:							return postfixOperatorSymbol
			case .end:										indexOutOfBounds
		}
	}
	
	public func index(before index: Index) -> Index {
		
		var indexBeforeSubexpression: Index {
			guard groupsSubexpression else { indexOutOfBounds }
			return .leadingBoundary
		}
		
		var lastIndexOfSubexpression: Index {
			guard let lastIndex = subexpression.indices.last else { return indexBeforeSubexpression }
			return .inSubexpression(innerIndex: lastIndex)
		}
		
		switch index {
			
			case .leadingBoundary:
			indexOutOfBounds
			
			case .inSubexpression(innerIndex: let innerIndex):
			guard innerIndex > subexpression.startIndex else { return indexBeforeSubexpression }
			return .inSubexpression(innerIndex: subexpression.index(before: innerIndex))
			
			case .trailingBoundary:
			return lastIndexOfSubexpression
			
			case .postfixOperator:
			return groupsSubexpression ? .trailingBoundary : lastIndexOfSubexpression
			
			case .end:
			return .postfixOperator
			
		}
		
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			
			case .leadingBoundary:
			guard let firstIndex = subexpression.indices.first else { return .trailingBoundary }
			return .inSubexpression(innerIndex: firstIndex)
			
			case .inSubexpression(innerIndex: let index):
			let nextIndex = subexpression.index(after: index)
			guard nextIndex < subexpression.endIndex else { return groupsSubexpression ? .trailingBoundary : .postfixOperator }
			return .inSubexpression(innerIndex: nextIndex)
			
			case .trailingBoundary:
			return .postfixOperator
			
			case .postfixOperator:
			return .end
			
			case .end:
			indexOutOfBounds
			
		}
	}
	
	private var groupsSubexpression: Bool {
		subexpression.bindingClass < self.bindingClass || subexpression.isEmpty
	}
	
}

public enum PostfixOperatorExpressionIndex<Subexpression : Expression> : Equatable {
	
	/// The position of the leading boundary.
	case leadingBoundary
	
	/// A position of a symbol in the subexpression.
	///
	/// - Invariant: `innerIndex` is an index to a symbol in the subexpression.
	///
	/// - Parameter innerIndex: The position of the symbol within the subexpression.
	case inSubexpression(innerIndex: Subexpression.Index)
	
	/// The position of the trailing boundary.
	case trailingBoundary
	
	/// The position of the postfix operator.
	case postfixOperator
	
	/// The position after the last symbol.
	case end
	
}

extension PostfixOperatorExpressionIndex : Comparable {
	public static func <(smallerIndex: Self, greaterIndex: Self) -> Bool {
		switch (smallerIndex, greaterIndex) {
			case (.leadingBoundary, .leadingBoundary):																return false
			case (.leadingBoundary, _):																				return true
			case (.inSubexpression, .leadingBoundary):																return false
			case (.inSubexpression(innerIndex: let smallerIndex), .inSubexpression(innerIndex: let greaterIndex)):	return smallerIndex < greaterIndex
			case (.inSubexpression, _):																				return true
			case (.trailingBoundary, .postfixOperator):																return true
			case (.trailingBoundary, .end):																			return true
			case (.trailingBoundary, _):																			return false
			case (.postfixOperator, .end):																			return true
			case (.postfixOperator, _):																				return false
			case (.end, _):																							return false
		}
	}
}
