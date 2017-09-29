// PatternKit © 2017 Constantino Tsarouhas

import DepthKit
import PatternKitBundle

/// A realisation of a concatenated regular expression with realisable subexpressions.
public struct RecursiveConcatenatedRegularExpressionRealisation<LeadingExpressionRealisation : Realisation, TrailingExpressionRealisation : Realisation> : Realisation where
	
	LeadingExpressionRealisation.Expression.Indices : BidirectionalCollection,
	TrailingExpressionRealisation.Expression.Indices : BidirectionalCollection,
	
	LeadingExpressionRealisation.PatternType.ForwardMatchCollection.Indices : OrderedCollection,
	TrailingExpressionRealisation.PatternType.ForwardMatchCollection.Indices : OrderedCollection,
	
	LeadingExpressionRealisation.PatternType.BackwardMatchCollection.Indices : OrderedCollection,
	TrailingExpressionRealisation.PatternType.BackwardMatchCollection.Indices : OrderedCollection {
	
	/// The type of the concatenated regular expression's leading expression.
	public typealias LeadingExpression = LeadingExpressionRealisation.Expression
	
	/// The type of the concatenated regular expression's trailing expression.
	public typealias TrailingExpression = TrailingExpressionRealisation.Expression
	
	// See protocol.
	public typealias Expression = ConcatenatedRegularExpression<LeadingExpression, TrailingExpression>
	
	// See protocol.
	public typealias PatternType = Concatenation<LeadingExpressionRealisation.PatternType, TrailingExpressionRealisation.PatternType>
	
	// See protocol.
	public init(of regularExpression: Expression) {
		TODO.unimplemented
	}
	
	// See protocol.
	public var pattern: PatternType {
		TODO.unimplemented
	}
	
}
