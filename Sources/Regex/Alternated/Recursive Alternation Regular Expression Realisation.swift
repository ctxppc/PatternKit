// PatternKit © 2017 Constantino Tsarouhas

import DepthKit
import PatternKitBundle

/// A realisation of an alternation regular expression with realisable subexpressions.
public struct RecursiveAlternationRegularExpressionRealisation<MainExpressionRealisation : Realisation, AlternativeExpressionRealisation : Realisation> : Realisation where
	
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
	public typealias Expression = AlternationRegularExpression<MainExpression, AlternativeExpression>
	
	// See protocol.
	public typealias PatternType = Alternation<MainExpressionRealisation.PatternType, AlternativeExpressionRealisation.PatternType>
	
	// See protocol.
	public init(of regularExpression: Expression) {
		TODO.unimplemented
	}
	
	// See protocol.
	public var pattern: PatternType {
		TODO.unimplemented
	}
	
}
