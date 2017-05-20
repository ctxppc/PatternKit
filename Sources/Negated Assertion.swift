// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that asserts that an asserted pattern does *not* match a part of the collection preceding or following the input position.
///
/// A negated assertion does not change the input position nor does it preserve any captures from tokens within the asserted pattern.
public struct NegatedAssertion<AssertedPattern : Pattern> {
	
	/// Creates a negated assertion.
	///
	/// - Parameter assertedPattern: The pattern that must produce at least one match for the assertion to hold.
	/// - Parameter direction: The direction from the input position onwards in which the asserted pattern must match for the assertion to hold.
	public init(_ assertedPattern: AssertedPattern, direction: MatchingDirection = .forward) {
		self.assertedPattern = assertedPattern
		self.direction = direction
	}
	
	/// The pattern that must not produce a match for the negated assertion to hold.
	public var assertedPattern: AssertedPattern
	
	/// The direction from the input position onwards in which the asserted pattern must not match for the negated assertion to hold.
	public var direction: MatchingDirection
	
}

extension NegatedAssertion : Pattern {
	
	public func matches(base: Match<AssertedPattern.Collection>, direction: MatchingDirection) -> AnyIterator<Match<AssertedPattern.Collection>> {
		unimplemented	// TODO
	}
	
}
