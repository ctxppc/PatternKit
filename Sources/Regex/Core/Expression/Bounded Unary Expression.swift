// PatternKit © 2017 Constantino Tsarouhas

import DepthKit

/// A unary expression that is a sequence consisting of a leading boundary symbol, the subexpression's symbols, and a trailing boundary symbol.
public protocol BoundedUnaryExpression : UnaryExpression {
	
	/// A symbol that indicates the expression's edges.
	associatedtype BoundarySymbol : BoundarySymbolProtocol
	
}

extension BoundedUnaryExpression where Subexpression.Indices : BidirectionalCollection {
	
	public typealias Index = BoundedUnaryExpressionIndex<Subexpression>
	
	public var startIndex: Index {
		return .leadingBoundary
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> SymbolProtocol {
		switch index {
			case .leadingBoundary:						return BoundarySymbol.boundaries.leading
			case .subexpression(innerIndex: let index):	return subexpression[index]
			case .trailingBoundary:						return BoundarySymbol.boundaries.trailing
			case .end:									indexOutOfBounds
		}
	}
	
	public func index(before index: Index) -> Index {
		switch index {
			
			case .leadingBoundary:
			indexOutOfBounds
			
			case .subexpression(innerIndex: let index):
			guard index > subexpression.startIndex else { return .leadingBoundary }
			return .subexpression(innerIndex: subexpression.index(before: index))
			
			case .trailingBoundary:
			guard let lastIndex = subexpression.indices.last else { return .leadingBoundary }
			return .subexpression(innerIndex: lastIndex)
			
			case .end:
			return .trailingBoundary
			
		}
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			
			case .leadingBoundary:
			guard let firstIndex = subexpression.indices.first else { return .trailingBoundary }
			return .subexpression(innerIndex: firstIndex)
			
			case .subexpression(innerIndex: let index):
			let nextIndex = subexpression.index(after: index)
			guard nextIndex < subexpression.endIndex else { return .trailingBoundary }
			return .subexpression(innerIndex: nextIndex)
			
			case .trailingBoundary:
			return .end
			
			case .end:
			indexOutOfBounds
			
		}
	}
	
	public var bindingClass: BindingClass {
		return .atomic
	}
	
}

public enum BoundedUnaryExpressionIndex<Subexpression : Expression> {
	
	/// The position of the leading boundary.
	case leadingBoundary
	
	/// A position of a symbol in the subexpression.
	///
	/// - Invariant: `innerIndex` is an index to a symbol in the subexpression.
	///
	/// - Parameter innerIndex: The position of the symbol within the subexpression.
	case subexpression(innerIndex: Subexpression.Index)
	
	/// The position of the trailing boundary.
	case trailingBoundary
	
	/// The position after the last symbol.
	case end
	
}

extension BoundedUnaryExpressionIndex : Comparable {
	
	public static func <(smallerIndex: BoundedUnaryExpressionIndex, greaterIndex: BoundedUnaryExpressionIndex) -> Bool {
		TODO.unimplemented
	}
	
	public static func ==(firstIndex: BoundedUnaryExpressionIndex, otherIndex: BoundedUnaryExpressionIndex) -> Bool {
		TODO.unimplemented
	}
	
}
