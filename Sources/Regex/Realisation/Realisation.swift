// PatternKit © 2017 Constantino Tsarouhas

import PatternKitCore

/// A value that converts a regular expression into a pattern.
///
/// Although not specified by this protocol, a realisation on a concrete pattern type may provide additional functionality such as mapping symbols to parts of patterns.
public protocol Realisation {
	
	/// The type of regular expression that is realised.
	associatedtype Expression : RegularExpression
	
	/// The type of pattern that results after realising the expression.
	associatedtype PatternType : Pattern where PatternType.Subject == String
	
	/// Realises given regular expression.
	///
	/// - Parameter regularExpression: The regular expression to realise.
	init(of regularExpression: Expression)
	
	/// The realised pattern.
	var pattern: PatternType { get }
	
}
