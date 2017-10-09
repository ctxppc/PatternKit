// PatternKit © 2017 Constantino Tsarouhas

import DepthKit
import PatternKitBundle

/// A realisation of a homogeneous concatenated expression with realisable subexpressions.
public struct HomogeneousConcatenatedExpressionRealisation<SubexpressionRealisation : Realisation> : Realisation
	where SubexpressionRealisation.ExpressionType.Indices : BidirectionalCollection {
	
	/// The type of the concatenated expression's subexpressions.
	public typealias Subexpression = SubexpressionRealisation.ExpressionType
	
	// See protocol.
	public init(of expression: HomogeneousConcatenatedExpression<Subexpression>) {
		realisationsOfSubexpressions = expression.subexpressions.map(SubexpressionRealisation.init)
	}
	
	/// The realisations of the subexpressions.
	public let realisationsOfSubexpressions: [SubexpressionRealisation]
	
	// See protocol.
	public var pattern: HomogeneousConcatenation<SubexpressionRealisation.PatternType> {
		return HomogeneousConcatenation(realisationsOfSubexpressions.map { $0.pattern })
	}
	
}
