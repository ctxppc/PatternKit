// PatternKit © 2017 Constantino Tsarouhas

import DepthKit
import PatternKitBundle

/// A realisation of an alternation regular expression with realisable subexpressions.
public struct AlternationRegularExpressionRealisation<MainExpressionRealisation : Realisation, AlternativeExpressionRealisation : Realisation> : Realisation where
	
	MainExpressionRealisation.Expression.Indices : BidirectionalCollection,
	AlternativeExpressionRealisation.Expression.Indices : BidirectionalCollection,
	
	MainExpressionRealisation.PatternType.ForwardMatchCollection.Indices : OrderedCollection,
	AlternativeExpressionRealisation.PatternType.ForwardMatchCollection.Indices : OrderedCollection,
	
	MainExpressionRealisation.PatternType.BackwardMatchCollection.Indices : OrderedCollection,
	AlternativeExpressionRealisation.PatternType.BackwardMatchCollection.Indices : OrderedCollection {
	
	/// The type of the alternation regular expression's main expression.
	public typealias MainExpression = MainExpressionRealisation.Expression
	
	/// The type of the alternation regular expression's alternative expression.
	public typealias AlternativeExpression = AlternativeExpressionRealisation.Expression
	
	// See protocol.
	public init(of regularExpression: AlternationRegularExpression<MainExpression, AlternativeExpression>) {
		realisationOfMainExpression = MainExpressionRealisation(of: regularExpression.mainExpression)
		realisationOfAlternativeExpression = AlternativeExpressionRealisation(of: regularExpression.alternativeExpression)
	}
	
	/// The realisation of the main expression.
	public let realisationOfMainExpression: MainExpressionRealisation
	
	/// The realisation of the alternative expression.
	public let realisationOfAlternativeExpression: AlternativeExpressionRealisation
	
	// See protocol.
	public var pattern: Alternation<MainExpressionRealisation.PatternType, AlternativeExpressionRealisation.PatternType> {
		return realisationOfMainExpression.pattern | realisationOfAlternativeExpression.pattern
	}
	
}
