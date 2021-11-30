// PatternKit © 2017–21 Constantino Tsarouhas

/// An expression that contains exactly one subexpression.
public protocol UnaryExpression : Expression {
	
	/// The type of subexpression.
	associatedtype Subexpression : Expression
	
	/// The subexpression.
	var subexpression: Subexpression { get }
	
}
