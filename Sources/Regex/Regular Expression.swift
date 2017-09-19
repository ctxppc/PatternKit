// PatternKit © 2017 Constantino Tsarouhas

/// A sequence of symbols and subexpressions that expresses a pattern to a regular expression engine.
public protocol RegularExpression {
	
	associatedtype Subject
	
	/// The (…)
	associatedtype SymbolCollection : BidirectionalCollection where SymbolCollection.Element : Symbol
	
	/// The type of subexpressions.
	associatedtype Subexpression /* : RegularExpression where Subexpression.Subject == Subject */		// TODO: Add when recursive conformances land in Swift.
	
	
}
