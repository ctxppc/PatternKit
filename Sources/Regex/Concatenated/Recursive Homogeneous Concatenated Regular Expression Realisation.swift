// PatternKit © 2017 Constantino Tsarouhas

import DepthKit
import PatternKitBundle

/// A realisation of a homogeneous concatenated regular expression with realisable subexpressions.
public struct RecursiveHomogeneousConcatenatedRegularExpressionRealisation<SubexpressionRealisation : Realisation> : Realisation
	where SubexpressionRealisation.Expression.Indices : BidirectionalCollection {
	
	/// The type of the concatenated regular expression's subexpressions.
	public typealias Subexpression = SubexpressionRealisation.Expression
	
	// See protocol.
	public typealias Expression = HomogeneousConcatenatedRegularExpression<Subexpression>
	
	// See protocol.
	public typealias PatternType = HomogeneousConcatenation<SubexpressionRealisation.PatternType>
	
	// See protocol.
	public init(of regularExpression: Expression) {
		TODO.unimplemented
	}
	
	// See protocol.
	public var pattern: PatternType {
		TODO.unimplemented
	}
	
}
