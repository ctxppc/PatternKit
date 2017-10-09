// PatternKit © 2017 Constantino Tsarouhas

import DepthKit
import PatternKitBundle

/// A realisation of a concatenated expression with realisable subexpressions.
public struct ConcatenatedExpressionRealisation<LeadingExpressionRealisation : Realisation, TrailingExpressionRealisation : Realisation> : Realisation where
	
	LeadingExpressionRealisation.ExpressionType.Indices : BidirectionalCollection,
	TrailingExpressionRealisation.ExpressionType.Indices : BidirectionalCollection,
	
	LeadingExpressionRealisation.PatternType.ForwardMatchCollection.Indices : OrderedCollection,
	TrailingExpressionRealisation.PatternType.ForwardMatchCollection.Indices : OrderedCollection,
	
	LeadingExpressionRealisation.PatternType.BackwardMatchCollection.Indices : OrderedCollection,
	TrailingExpressionRealisation.PatternType.BackwardMatchCollection.Indices : OrderedCollection {
	
	/// The type of the concatenated expression's leading expression.
	public typealias LeadingExpression = LeadingExpressionRealisation.ExpressionType
	
	/// The type of the concatenated expression's trailing expression.
	public typealias TrailingExpression = TrailingExpressionRealisation.ExpressionType
	
	// See protocol.
	public init(of expression: ConcatenatedExpression<LeadingExpression, TrailingExpression>) {
		realisationOfLeadingExpression = LeadingExpressionRealisation(of: expression.leadingExpression)
		realisationOfTrailingExpression = TrailingExpressionRealisation(of: expression.trailingExpression)
	}
	
	/// The realisation of the leading expression.
	public let realisationOfLeadingExpression: LeadingExpressionRealisation
	
	/// The realisation of the trailing expression.
	public let realisationOfTrailingExpression: TrailingExpressionRealisation
	
	// See protocol.
	public var pattern: Concatenation<LeadingExpressionRealisation.PatternType, TrailingExpressionRealisation.PatternType> {
		return realisationOfLeadingExpression.pattern • realisationOfTrailingExpression.pattern
	}
	
}
