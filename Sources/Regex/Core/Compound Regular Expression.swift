// PatternKit © 2017 Constantino Tsarouhas

/// A regular expression that consists of subexpressions.
public protocol CompoundRegularExpression : RegularExpression {
	
	/// The type of subexpressions.
	associatedtype Subexpression : RegularExpression where Subexpression.Subject == Subject
	
	/// The type of subexpression collections.
	associatedtype SubexpressionCollection : BidirectionalCollection where
		SubexpressionCollection.Element == Subexpression,
		SubexpressionCollection.Indices : BidirectionalCollection,
		SubexpressionCollection.SubSequence : BidirectionalCollection,
		SubexpressionCollection.SubSequence.Indices : BidirectionalCollection	// TODO: Remove BidirectionalCollection constraints when recursive conformances land in Swift
	
	/// The subexpressions.
	var subexpressions: SubexpressionCollection { get set }
	
}
