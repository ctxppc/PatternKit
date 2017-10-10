// PatternKit © 2017 Constantino Tsarouhas

import DepthKit

/// An expression that expresses an arbitrary negated backward assertion.
public struct NegatedBackwardAssertionExpression<Subexpression : Expression> where Subexpression.Indices : BidirectionalCollection {
	
	/// Creates a negated backward assertion expression with given subexpression.
	///
	/// - Parameter comment: The expression that expresses the negatively asserted pattern.
	public init(_ subexpression: Subexpression) {
		self.subexpression = subexpression
	}
	
	/// The expression that expresses the negatively asserted pattern.
	public var subexpression: Subexpression
	
}

extension NegatedBackwardAssertionExpression : BoundedUnaryExpression {
	
	public enum BoundarySymbol {
		
		/// A symbol that represents the leading boundary.
		case leadingBoundary
		
		/// A symbol that represents the trailing boundary.
		case trailingBoundary
		
	}
	
}

extension NegatedBackwardAssertionExpression.BoundarySymbol : BoundarySymbolProtocol {
	
	public static var boundaries: (leading: NegatedBackwardAssertionExpression.BoundarySymbol, trailing: NegatedBackwardAssertionExpression.BoundarySymbol) {
		return (.leadingBoundary, .trailingBoundary)
	}
	
	public func serialisation(language: Language) throws -> String {
		guard language == .perlCompatibleREs else { throw SymbolSerialisationError.unsupportedByLanguage }
		switch self {
			case .leadingBoundary:	return "(?<!"
			case .trailingBoundary:	return ")"
		}
	}
	
}
