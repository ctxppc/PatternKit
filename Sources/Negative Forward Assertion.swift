// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that performs matching of an asserting pattern from the current input position onwards, does not advance the input position of matches beyond the assertion, and produces exactly one match if the asserting pattern *does not* produce a match; also known as a negative lookahead.
///
/// Note that, given that a negative assertion never produces a match if its asserting pattern does, tokens within an asserting pattern do not capture and are effectively no-ops.
public struct NegativeForwardAssertion<AssertingPattern : Pattern> {
	
	/// The pattern that is matched without advancing the input position.
	///
	/// If the pattern produces matches, the assertion fails and produces no matches itself.
	public var assertingPattern: AssertingPattern
	
}

extension NegativeForwardAssertion : Pattern {
	
	public func matches(base: Match<AssertingPattern.Collection>, direction: MatchingDirection) -> AnyIterator<Match<AssertingPattern.Collection>> {
		unimplemented	// TODO
	}
	
}
