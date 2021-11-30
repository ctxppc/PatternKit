// PatternKit © 2017–21 Constantino Tsarouhas

import DepthKit

/// An expression that expresses a repeating pattern.
public struct EagerlyRepeatingExpression<Subexpression : Expression> {
	
	/// Creates a repeating expression with given subexpression.
	///
	/// - Parameter comment: The expression that expresses the repeated pattern.
	public init(_ subexpression: Subexpression, multiplicityRange: MultiplicityRange, possessive: Bool = false) {
		self.subexpression = subexpression
		self.multiplicityRange = multiplicityRange
		self.possessive = possessive
	}
	
	/// The expression that expresses the repeated pattern.
	public var subexpression: Subexpression
	
	/// The multiplicity range.
	public var multiplicityRange: MultiplicityRange
	
	/// Whether the repeating pattern is possessive.
	var possessive: Bool
	
	public struct QuantifierSymbol {
		
		/// The multiplicity range.
		var multiplicityRange: MultiplicityRange
		
		/// Whether the repeating pattern is possessive.
		///
		/// - Invariant: If `true`, the multiplicity contains at least two members.
		var possessive: Bool
		
	}
	
}

extension EagerlyRepeatingExpression : PostfixOperatorExpression {
	public typealias Index = PostfixOperatorExpressionIndex<Subexpression>
	public static var leadingBoundarySymbol: SymbolProtocol { NoncapturingGroupBoundarySymbol.leading }
	public static var trailingBoundarySymbol: SymbolProtocol { NoncapturingGroupBoundarySymbol.trailing }
	public var postfixOperatorSymbol: SymbolProtocol { QuantifierSymbol(multiplicityRange: multiplicityRange, possessive: possessive) }
	public var bindingClass: BindingClass { .quantified }
}

extension EagerlyRepeatingExpression.QuantifierSymbol : SymbolProtocol {
	public func serialisation(language: Language) throws -> String {
		if possessive {
			guard [.perlCompatibleREs].contains(language) else { throw SymbolSerialisationError.unsupportedByLanguage }
			return "\(multiplicityRange.serialisation)+"
		} else {
			return multiplicityRange.serialisation
		}
	}
}
