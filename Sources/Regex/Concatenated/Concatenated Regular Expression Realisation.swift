// PatternKit © 2017 Constantino Tsarouhas

import DepthKit
import PatternKitBundle

/// A realisation of a concatenated regular expression with realisable subexpressions.
public struct ConcatenatedRegularExpressionRealisation<LeadingExpressionRealisation : Realisation, TrailingExpressionRealisation : Realisation> : Realisation where
	
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
	public init(of regularExpression: ConcatenatedRegularExpression<LeadingExpression, TrailingExpression>) {
		realisationOfLeadingExpression = LeadingExpressionRealisation(of: regularExpression.leadingExpression)
		realisationOfTrailingExpression = TrailingExpressionRealisation(of: regularExpression.trailingExpression)
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
