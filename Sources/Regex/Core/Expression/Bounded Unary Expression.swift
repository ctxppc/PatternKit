// PatternKit © 2017–21 Constantino Tsarouhas

import DepthKit

/// A unary expression that is a sequence consisting of a leading boundary symbol, the subexpression's symbols, and a trailing boundary symbol.
public protocol BoundedUnaryExpression : UnaryExpression {
	
	/// The symbol leading the subexpression.
	static var leadingBoundarySymbol: SymbolProtocol { get }
	
	/// The symbol trailing the subexpression.
	static var trailingBoundarySymbol: SymbolProtocol { get }
	
}

extension BoundedUnaryExpression where Index == BoundedUnaryExpressionIndex<Subexpression> {
	
	public var startIndex: Index {
		return .leadingBoundary
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> SymbolProtocol {
		switch index {
			case .leadingBoundary:							return Self.leadingBoundarySymbol
			case .inSubexpression(innerIndex: let index):	return subexpression[index]
			case .trailingBoundary:							return Self.trailingBoundarySymbol
			case .end:										indexOutOfBounds
		}
	}
	
	public func index(before index: Index) -> Index {
		switch index {
			
			case .leadingBoundary:
			indexOutOfBounds
			
			case .inSubexpression(innerIndex: let index):
			guard index > subexpression.startIndex else { return .leadingBoundary }
			return .inSubexpression(innerIndex: subexpression.index(before: index))
			
			case .trailingBoundary:
			guard let lastIndex = subexpression.indices.last else { return .leadingBoundary }
			return .inSubexpression(innerIndex: lastIndex)
			
			case .end:
			return .trailingBoundary
			
		}
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			
			case .leadingBoundary:
			guard let firstIndex = subexpression.indices.first else { return .trailingBoundary }
			return .inSubexpression(innerIndex: firstIndex)
			
			case .inSubexpression(innerIndex: let index):
			let nextIndex = subexpression.index(after: index)
			guard nextIndex < subexpression.endIndex else { return .trailingBoundary }
			return .inSubexpression(innerIndex: nextIndex)
			
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

public enum BoundedUnaryExpressionIndex<Subexpression : Expression> : Equatable {
	
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
	
	/// The position after the last symbol.
	case end
	
}

extension BoundedUnaryExpressionIndex : Comparable {
	public static func < (smallerIndex: BoundedUnaryExpressionIndex, greaterIndex: BoundedUnaryExpressionIndex) -> Bool {
		switch (smallerIndex, greaterIndex) {
			case (.leadingBoundary, .leadingBoundary):																return false
			case (.leadingBoundary, _):																				return true
			case (.inSubexpression, .leadingBoundary):																return false
			case (.inSubexpression(innerIndex: let smallerIndex), .inSubexpression(innerIndex: let greaterIndex)):	return smallerIndex < greaterIndex
			case (.inSubexpression, _):																				return true
			case (.trailingBoundary, .end):																			return true
			case (.trailingBoundary, _):																			return false
			case (.end, _):																							return false
		}
	}
}
