// PatternKit © 2017 Constantino Tsarouhas

import PatternKitCore

/// A value that converts a regular expression into a pattern.
///
/// Although not specified by this protocol, a realisation on a concrete pattern type may provide additional functionality such as mapping symbols to parts of patterns.
public protocol Realisation {
	
	/// The type of the realised regular expression.
	associatedtype Expression : RegularExpression
	
	/// The type of the pattern that results after realising the expression.
	associatedtype PatternType : Pattern where PatternType.Subject == String
	
	/// Realises given regular expression.
	///
	/// - Parameter regularExpression: The regular expression to realise.
	init(of regularExpression: Expression)
	
	/// The resulting pattern.
	var pattern: PatternType { get }
	
}
