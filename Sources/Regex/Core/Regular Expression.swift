// PatternKit © 2017 Constantino Tsarouhas

import DepthKit

/// A sequence of symbols and subexpressions that expresses a pattern to a regular expression engine.
public protocol RegularExpression {
	
	/// The type of the subjects matched over by patterns.
	associatedtype Subject : BidirectionalCollection where Subject : Equatable
	
	/// The type of symbol collections.
	associatedtype SymbolCollection : BidirectionalCollection where
		SymbolCollection.Element == Symbol,
		SymbolCollection.Indices : BidirectionalCollection,
		SymbolCollection.SubSequence : BidirectionalCollection,
		SymbolCollection.SubSequence.Indices : BidirectionalCollection	// TODO: Remove BidirectionalCollection constraints when recursive conformances land in Swift
	
	/// The symbols that form the regular expression.
	var symbols: SymbolCollection { get }
	
}
