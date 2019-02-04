// PatternKit © 2017–19 Constantino Tsarouhas

import DepthKit

/// An expression that expresses a repeating pattern.
public struct LazilyRepeatingExpression<Subexpression : Expression> {
	
	/// Creates a repeating expression with given subexpression.
	///
	/// - Parameter comment: The expression that expresses the repeated pattern.
	public init(_ subexpression: Subexpression, multiplicityRange: MultiplicityRange) {
		self.subexpression = subexpression
		self.multiplicityRange = multiplicityRange
	}
	
	/// The expression that expresses the repeated pattern.
	public var subexpression: Subexpression
	
	/// The multiplicity range.
	public var multiplicityRange: MultiplicityRange
	
	public struct QuantifierSymbol {
		
		/// The multiplicity range.
		var multiplicityRange: MultiplicityRange
		
	}
	
}

extension LazilyRepeatingExpression : PostfixOperatorExpression {
	
	public typealias Index = PostfixOperatorExpressionIndex<Subexpression>
	
	public static var leadingBoundarySymbol: SymbolProtocol {
		return NoncapturingGroupBoundarySymbol.leading
	}
	
	public static var trailingBoundarySymbol: SymbolProtocol {
		return NoncapturingGroupBoundarySymbol.trailing
	}
	
	public var postfixOperatorSymbol: SymbolProtocol {
		return QuantifierSymbol(multiplicityRange: multiplicityRange)
	}
	
	public var bindingClass: BindingClass {
		return .quantified
	}
	
}

extension LazilyRepeatingExpression.QuantifierSymbol : SymbolProtocol {
	public func serialisation(language: Language) throws -> String {
		return "\(multiplicityRange.serialisation)?"
	}
}
