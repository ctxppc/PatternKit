// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that performs matching of an asserting pattern from the current input position onwards, does not advance the input position of matches beyond the assertion, and produces exactly one match if the asserting pattern produces a match; also known as a positive lookahead.
///
/// A forward assertion is also a singular pattern: as soon as it finds one match over its asserting pattern, it does not generate more matches over its asserting pattern. This does not affect pattern matching in general since the input position isn't affected by an assertion pattern, but it does affect the tokens used within the asserting pattern since the assertion pattern will not permute over all possible captures of the asserting pattern's tokens.
///
/// Note that, given that a forward assertion does not advance the input position for pattern matching beyond itself, tokens within the assertion may have capture ranges that exceed the assertion's final input position.
public struct ForwardAssertion<AssertingPattern : Pattern> {
	
	/// The pattern that is matched without advancing the input position.
	///
	/// If the pattern does not produce matches, the assertion fails and produces no matches itself.
	public var assertingPattern: AssertingPattern
	
}

extension ForwardAssertion : Pattern {
	
	public func matches(proceedingFrom origin: Match<AssertingPattern.Collection>) -> AnyIterator<Match<AssertingPattern.Collection>> {
		unimplemented	// TODO
	}
	
}
