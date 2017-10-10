// PatternKit © 2017 Constantino Tsarouhas

import DepthKit

/// An expression that expresses an arbitrary backward assertion.
///
/// Some languages support backward assertions but not arbitrary backward assertions. Typical constraints involve the length of the backward matched substring.
public struct BackwardAssertionExpression<Subexpression : Expression> where Subexpression.Indices : BidirectionalCollection {
	
	/// Creates a backward assertion expression with given subexpression.
	///
	/// - Parameter comment: The expression that expresses the asserted pattern.
	public init(_ subexpression: Subexpression) {
		self.subexpression = subexpression
	}
	
	/// The expression that expresses the asserted pattern.
	public var subexpression: Subexpression
	
}

extension BackwardAssertionExpression : BoundedUnaryExpression {
	
	public enum BoundarySymbol {
		
		/// A symbol that represents the leading boundary.
		case leadingBoundary
		
		/// A symbol that represents the trailing boundary.
		case trailingBoundary
		
	}
	
}

extension BackwardAssertionExpression.BoundarySymbol : BoundarySymbolProtocol {
	
	public static var boundaries: (leading: BackwardAssertionExpression.BoundarySymbol, trailing: BackwardAssertionExpression.BoundarySymbol) {
		return (.leadingBoundary, .trailingBoundary)
	}
	
	public func serialisation(language: Language) throws -> String {
		guard language == .perlCompatibleREs else { throw SymbolSerialisationError.unsupportedByLanguage }
		switch self {
			case .leadingBoundary:	return "(?<="
			case .trailingBoundary:	return ")"
		}
	}
	
}
