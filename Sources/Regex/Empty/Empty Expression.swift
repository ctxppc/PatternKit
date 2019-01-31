// PatternKit © 2017–19 Constantino Tsarouhas

import DepthKit

/// An expression with no symbols.
public struct EmptyExpression {}

extension EmptyExpression : Expression {
	
	public enum Index : Equatable {
		case end
	}
	
	public var startIndex: Index {
		return .end
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> SymbolProtocol {
		indexOutOfBounds
	}
	
	public func index(before index: Index) -> Index {
		indexOutOfBounds
	}
	
	public func index(after index: Index) -> Index {
		indexOutOfBounds
	}
	
	public var bindingClass: BindingClass {
		return .atomic
	}
	
}

extension EmptyExpression.Index : Comparable {
	public static func < (smallerIndex: EmptyExpression.Index, greaterIndex: EmptyExpression.Index) -> Bool {
		return false
	}
}
