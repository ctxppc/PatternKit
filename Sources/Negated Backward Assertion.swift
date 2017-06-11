// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that asserts that an asserted pattern does *not* match the part of the subject preceding the input position; also known as a negative lookbehind.
///
/// A negated assertion does not change the input position nor does it preserve any captures from tokens within the asserted pattern. Tokens within the asserted pattern essentially do not affect matching outside of the assertion, but can be used for reference patterns also contained within the assertion.
public struct NegatedBackwardAssertion<AssertedPattern : Pattern> {
	
	public typealias Subject = AssertedPattern.Subject
	
	/// Creates a negated forward assertion.
	///
	/// - Parameter assertedPattern: The pattern that must produce at least one match for the assertion to hold.
	public init(_ assertedPattern: AssertedPattern) {
		self.assertedPattern = assertedPattern
	}
	
	/// The pattern that must not produce a match for the negated assertion to hold.
	public var assertedPattern: AssertedPattern
	
}

extension NegatedBackwardAssertion : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<AssertedPattern.Subject>) -> NegatedBackwardAssertionMatchCollection<AssertedPattern> {
		return NegatedBackwardAssertionMatchCollection(assertedPattern: assertedPattern, baseMatch: base)
	}
	
	public func backwardMatches(recedingFrom base: Match<AssertedPattern.Subject>) -> NegatedForwardAssertionMatchCollection<AssertedPattern> {
		return NegatedForwardAssertionMatchCollection(assertedPattern: assertedPattern, baseMatch: base)
	}
	
}
