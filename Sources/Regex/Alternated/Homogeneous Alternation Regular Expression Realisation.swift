// PatternKit © 2017 Constantino Tsarouhas

import DepthKit
import PatternKitBundle

/// A realisation of a homogeneous alternation regular expression with realisable subexpressions.
public struct HomogeneousAlternationRegularExpressionRealisation<SubexpressionRealisation : Realisation> : Realisation
	where SubexpressionRealisation.Expression.Indices : BidirectionalCollection {
	
	/// The type of the alternation regular expression's subexpressions.
	public typealias Subexpression = SubexpressionRealisation.Expression
	
	// See protocol.
	public init(of regularExpression: HomogeneousAlternationRegularExpression<Subexpression>) {
		realisationsOfSubexpressions = regularExpression.subexpressions.map(SubexpressionRealisation.init)
	}
	
	/// The realisations of the subexpressions.
	public let realisationsOfSubexpressions: [SubexpressionRealisation]
	
	// See protocol.
	public var pattern: HomogeneousAlternation<SubexpressionRealisation.PatternType> {
		return HomogeneousAlternation(realisationsOfSubexpressions.map { $0.pattern })
	}
	
}
