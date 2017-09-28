// PatternKit © 2017 Constantino Tsarouhas

import PatternKitCore

/// A sequence of symbols that expresses a pattern that matches over strings.
///
/// While every (valid) regular expression expresses a pattern, it does not do so uniquely. For example, a range set regular expression expresses the same pattern after its ranges have been rearranged. Additionally, a pattern type may be expressible by several types of regular expression.
public protocol RegularExpression : BidirectionalCollection where Element : Symbol {
	
	/// The type of patterns expressed by regular expressions.
	associatedtype PatternType : Pattern where PatternType.Subject == String
	
	/// Returns a canonical pattern expressed by the regular expression.
	///
	/// - Throws: An error if the pattern couldn't be created or determined.
	///
	/// - Returns: A canonical pattern.
	func makePattern() throws -> PatternType
	
}
