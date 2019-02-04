// PatternKit © 2017–19 Constantino Tsarouhas

import DepthKit

/// An expression that expresses an arbitrary negated backward assertion.
public struct NegatedBackwardAssertionExpression<Subexpression : Expression> {
	
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
	
	public typealias Index = BoundedUnaryExpressionIndex<Subexpression>
	
	public static var leadingBoundarySymbol: SymbolProtocol {
		return BoundarySymbol.leading
	}
	
	public static var trailingBoundarySymbol: SymbolProtocol {
		return BoundarySymbol.trailing
	}
	
	public enum BoundarySymbol : SymbolProtocol {
		
		/// A symbol that represents the leading boundary.
		case leading
		
		/// A symbol that represents the trailing boundary.
		case trailing
		
		// See protocol.
		public func serialisation(language: Language) throws -> String {
			guard language == .perlCompatibleREs else { throw SymbolSerialisationError.unsupportedByLanguage }
			switch self {
				case .leading:	return "(?<!"
				case .trailing:	return ")"
			}
		}
		
	}
	
}
