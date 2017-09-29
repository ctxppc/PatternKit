// PatternKit © 2017 Constantino Tsarouhas

import DepthKit
import PatternKitBundle

/// A realisation of a homogeneous alternation regular expression with realisable subexpressions.
public struct RecursiveHomogeneousAlternationRegularExpressionRealisation<SubexpressionRealisation : Realisation> : Realisation
	where SubexpressionRealisation.Expression.Indices : BidirectionalCollection {
	
	/// The type of the alternation regular expression's subexpressions.
	public typealias Subexpression = SubexpressionRealisation.Expression
	
	// See protocol.
	public typealias Expression = HomogeneousAlternationRegularExpression<Subexpression>
	
	// See protocol.
	public typealias PatternType = HomogeneousAlternation<SubexpressionRealisation.PatternType>
	
	// See protocol.
	public init(of regularExpression: Expression) {
		TODO.unimplemented
	}
	
	// See protocol.
	public var pattern: PatternType {
		TODO.unimplemented
	}
	
}
