// PatternKit © 2017–21 Constantino Tsarouhas

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
	
	public typealias Index = BoundedUnaryExpressionIndex<Subexpression>
	
	public static var leadingBoundarySymbol: SymbolProtocol { BoundarySymbol.leading }
	
	public static var trailingBoundarySymbol: SymbolProtocol { BoundarySymbol.trailing }
	
	public enum BoundarySymbol : SymbolProtocol {
		
		/// A symbol that represents the leading boundary.
		case leading
		
		/// A symbol that represents the trailing boundary.
		case trailing
		
		// See protocol.
		public func serialisation(language: Language) -> String {
			switch self {
				case .leading:	return "(?="
				case .trailing:	return ")"
			}
		}
		
	}
	
}
