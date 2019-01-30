// PatternKit © 2017–19 Constantino Tsarouhas

import DepthKit

/// An expression that expresses a forward assertion.
public struct ForwardAssertionExpression<Subexpression : Expression> {
	
	/// Creates a forward assertion expression with given subexpression.
	///
	/// - Parameter comment: The expression that expresses the asserted pattern.
	public init(_ subexpression: Subexpression) {
		self.subexpression = subexpression
	}
	
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
	
	public static var boundaries: (leading: ForwardAssertionExpression.BoundarySymbol, trailing: ForwardAssertionExpression.BoundarySymbol) {
		return (.leadingBoundary, .trailingBoundary)
	}
	
	public func serialisation(language: Language) -> String {
		switch self {
			case .leadingBoundary:	return "(?="
			case .trailingBoundary:	return ")"
		}
	}
	
}
