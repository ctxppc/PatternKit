// PatternKit © 2017 Constantino Tsarouhas

import DepthKit

/// An expression that expresses a forward assertion.
public struct NegatedForwardAssertionExpression<Subexpression : Expression> where Subexpression.Indices : BidirectionalCollection {
	
	/// The expression that expresses the asserted pattern.
	public var subexpression: Subexpression
	
}

extension NegatedForwardAssertionExpression : BoundedUnaryExpression {
	
	public enum BoundarySymbol {
		
		/// A symbol that represents the leading boundary.
		case leadingBoundary
		
		/// A symbol that represents the trailing boundary.
		case trailingBoundary
		
	}
	
}

extension NegatedForwardAssertionExpression.BoundarySymbol : BoundarySymbolProtocol {
	
	public static var boundaries: (leading: NegatedForwardAssertionExpression.BoundarySymbol, trailing: NegatedForwardAssertionExpression.BoundarySymbol) {
		return (.leadingBoundary, .trailingBoundary)
	}
	
	public func serialisation(language: Language) throws -> String {
		TODO.unimplemented
	}
	
}
