// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that asserts that an asserted pattern does *not* match the part of the subject following the input position; also known as a negative lookahead.
///
/// For example, `NegatedForwardAssertion(Repeating(1...9, min: 5)) • Literal([1, 2, 3]) • any()+` matches all arrays starting with the elements 1, 2, and 3 that do not start with 5 elements between 1 and 9.
///
/// A negated assertion does not change the input position nor does it preserve any captures from tokens within the asserted pattern. Tokens within the asserted pattern essentially do not affect matching outside of the assertion, but can be used for reference patterns also contained within the assertion.
public struct NegatedForwardAssertion<AssertedPattern : Pattern> {
	
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

extension NegatedForwardAssertion : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<AssertedPattern.Subject>) -> NegatedForwardAssertionMatchCollection<AssertedPattern> {
		return NegatedForwardAssertionMatchCollection(assertedPattern: assertedPattern, baseMatch: base)
	}
	
	public func backwardMatches(recedingFrom base: Match<AssertedPattern.Subject>) -> NegatedBackwardAssertionMatchCollection<AssertedPattern> {
		return NegatedBackwardAssertionMatchCollection(assertedPattern: assertedPattern, baseMatch: base)
	}
	
}
