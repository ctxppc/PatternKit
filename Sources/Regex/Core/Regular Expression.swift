// PatternKit © 2017 Constantino Tsarouhas

import PatternKitCore

/// A sequence of symbols that expresses a pattern.
public protocol RegularExpression : BidirectionalCollection where Element == Symbol {
	
	/// The type of subjects matched over by patterns.
	typealias Subject = PatternType.Subject
	
	/// The type of patterns expressed by regular expressions.
	associatedtype PatternType : Pattern
	
	/// The pattern expressed by the regular expression.
	var pattern: PatternType { get }
	
}
