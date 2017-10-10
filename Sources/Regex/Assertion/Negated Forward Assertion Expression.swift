// PatternKit © 2017 Constantino Tsarouhas

import DepthKit

/// An expression that expresses a negated forward assertion.
public struct NegatedForwardAssertionExpression<Subexpression : Expression> where Subexpression.Indices : BidirectionalCollection {
	
	/// Creates a negated forward assertion expression with given subexpression.
	///
	/// - Parameter comment: The expression that expresses the negatively asserted pattern.
	public init(_ subexpression: Subexpression) {
		self.subexpression = subexpression
	}
	
	/// The expression that expresses the negatively asserted pattern.
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
	
	public func serialisation(language: Language) -> String {
		switch self {
			case .leadingBoundary:	return "(?!"
			case .trailingBoundary:	return ")"
		}
	}
	
}
