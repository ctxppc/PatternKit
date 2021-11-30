// PatternKit © 2017–21 Constantino Tsarouhas

import DepthKit

/// An expression that expresses an arbitrary backward assertion.
///
/// Some languages support backward assertions but not arbitrary backward assertions. Typical constraints involve the length of the backward matched substring.
public struct BackwardAssertionExpression<Subexpression : Expression> {
	
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
	
	public typealias Index = BoundedUnaryExpressionIndex<Subexpression>
	
	public static var leadingBoundarySymbol: SymbolProtocol { BoundarySymbol.leading }
	
	public static var trailingBoundarySymbol: SymbolProtocol { BoundarySymbol.trailing }
	
	public enum BoundarySymbol : SymbolProtocol {
		
		/// A symbol that represents the leading boundary.
		case leading
		
		/// A symbol that represents the trailing boundary.
		case trailing
		
		// See protocol.
		public func serialisation(language: Language) throws -> String {
			guard language == .perlCompatibleREs else { throw SymbolSerialisationError.unsupportedByLanguage }
			switch self {
				case .leading:	return "(?<="
				case .trailing:	return ")"
			}
		}
		
	}
	
}
