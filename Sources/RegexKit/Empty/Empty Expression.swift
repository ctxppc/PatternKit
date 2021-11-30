// PatternKit © 2017–21 Constantino Tsarouhas

import DepthKit

/// An expression with no symbols.
public struct EmptyExpression {
	
	/// Creates an empty expression.
	public init() {}
	
}

extension EmptyExpression : Expression {
	
	public enum Index : Equatable {
		case end
	}
	
	public var startIndex: Index { .end }
	public var endIndex: Index { .end }
	public subscript (index: Index) -> SymbolProtocol { indexOutOfBounds }
	public func index(before index: Index) -> Index { indexOutOfBounds }
	public func index(after index: Index) -> Index { indexOutOfBounds }
	public var bindingClass: BindingClass { .atomic }
	
}

extension EmptyExpression.Index : Comparable {
	public static func <(smallerIndex: Self, greaterIndex: Self) -> Bool {
		false
	}
}
