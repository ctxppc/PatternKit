// PatternKit © 2017 Constantino Tsarouhas

import DepthKit
import PatternKitBundle

/// A realisation of a homogeneous concatenated regular expression with realisable subexpressions.
public struct HomogeneousConcatenatedRegularExpressionRealisation<SubexpressionRealisation : Realisation> : Realisation
	where SubexpressionRealisation.Expression.Indices : BidirectionalCollection {
	
	/// The type of the concatenated regular expression's subexpressions.
	public typealias Subexpression = SubexpressionRealisation.Expression
	
	// See protocol.
	public init(of regularExpression: HomogeneousConcatenatedRegularExpression<Subexpression>) {
		realisationsOfSubexpressions = regularExpression.subexpressions.map(SubexpressionRealisation.init)
	}
	
	/// The realisations of the subexpressions.
	public let realisationsOfSubexpressions: [SubexpressionRealisation]
	
	// See protocol.
	public var pattern: HomogeneousConcatenation<SubexpressionRealisation.PatternType> {
		return HomogeneousConcatenation(realisationsOfSubexpressions.map { $0.pattern })
	}
	
}
