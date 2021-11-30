// PatternKit © 2017–21 Constantino Tsarouhas

import DepthKit
import PatternKit

/// A realisation of a homogeneous alternation expression with realisable subexpressions.
public struct HomogeneousAlternationRegularExpressionRealisation<SubexpressionRealisation : Realisation> : Realisation {
	
	/// The type of the alternation expression's subexpressions.
	public typealias Subexpression = SubexpressionRealisation.ExpressionType
	
	// See protocol.
	public init(of expression: HomogeneousAlternationExpression<Subexpression>) {
		realisationsOfSubexpressions = expression.subexpressions.map(SubexpressionRealisation.init)
	}
	
	/// The realisations of the subexpressions.
	public let realisationsOfSubexpressions: [SubexpressionRealisation]
	
	// See protocol.
	public var pattern: HomogeneousAlternation<SubexpressionRealisation.PatternType> {
		.init(realisationsOfSubexpressions.map { $0.pattern })
	}
	
}
