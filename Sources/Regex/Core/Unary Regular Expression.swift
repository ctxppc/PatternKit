// PatternKit © 2017 Constantino Tsarouhas

/// A regular expression that consists of a subexpression.
public protocol UnaryRegularExpression : RegularExpression {
	
	/// The type of subexpressions.
	associatedtype Subexpression : RegularExpression where Subexpression.Subject == Subject
	
	/// The subexpression.
	var subexpression: Subexpression { get set }
	
}
