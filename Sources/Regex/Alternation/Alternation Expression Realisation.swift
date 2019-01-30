// PatternKit © 2017–19 Constantino Tsarouhas

import DepthKit
import PatternKitBundle

/// A realisation of an alternation expression with realisable subexpressions.
public struct AlternationExpressionRealisation<MainExpressionRealisation : Realisation, AlternativeExpressionRealisation : Realisation> : Realisation where
	
	MainExpressionRealisation.PatternType.ForwardMatchCollection.Indices : OrderedCollection,
	AlternativeExpressionRealisation.PatternType.ForwardMatchCollection.Indices : OrderedCollection,
	
	MainExpressionRealisation.PatternType.BackwardMatchCollection.Indices : OrderedCollection,
	AlternativeExpressionRealisation.PatternType.BackwardMatchCollection.Indices : OrderedCollection {
	
	/// The type of the alternation expression's main expression.
	public typealias MainExpression = MainExpressionRealisation.ExpressionType
	
	/// The type of the alternation expression's alternative expression.
	public typealias AlternativeExpression = AlternativeExpressionRealisation.ExpressionType
	
	// See protocol.
	public init(of expression: AlternationExpression<MainExpression, AlternativeExpression>) {
		realisationOfMainExpression = MainExpressionRealisation(of: expression.mainExpression)
		realisationOfAlternativeExpression = AlternativeExpressionRealisation(of: expression.alternativeExpression)
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
