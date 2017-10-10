// PatternKit © 2017 Constantino Tsarouhas

import DepthKit

/// An expression that expresses a forward assertion.
public struct ForwardAssertionExpression<Subexpression : Expression> where Subexpression.Indices : BidirectionalCollection {
	
	/// The expression that expresses the asserted pattern.
	public var subexpression: Subexpression
	
	
}

extension ForwardAssertionExpression : BoundedUnaryExpression {
	
	public enum BoundarySymbol {
		
		/// A symbol that represents the leading boundary.
		case leadingBoundary
		
		/// A symbol that represents the trailing boundary.
		case trailingBoundary
		
	}
	
}

extension ForwardAssertionExpression.BoundarySymbol : BoundarySymbolProtocol {
	
	public static var boundaries: (leading: ForwardAssertionExpression<Subexpression>.BoundarySymbol, trailing: ForwardAssertionExpression<Subexpression>.BoundarySymbol) {
		return (.leadingBoundary, .trailingBoundary)
	}
	
	public func serialisation(language: Language) throws -> String {
		TODO.unimplemented
	}
	
}
