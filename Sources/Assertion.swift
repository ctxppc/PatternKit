// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that asserts that an asserted pattern matches the part of the collection preceding or following the input position, without actually moving the input position beyond the assertion.
///
/// While the assertion does not change the input position, it does preserve captures by tokens contained within the asserted pattern. However, the assertion only produces one match from the asserted pattern.
public struct Assertion<AssertedPattern : Pattern> {
	
	/// Creates an assertion.
	///
	/// - Parameter assertedPattern: The pattern that must produce at least one match for the assertion to hold.
	/// - Parameter direction: The direction from the input position onwards in which the asserted pattern must match for the assertion to hold.
	public init(_ assertedPattern: AssertedPattern, direction: MatchingDirection = .forward) {
		self.assertedPattern = assertedPattern
		self.direction = direction
	}
	
	/// The pattern that must produce at least one match for the assertion to hold.
	public var assertedPattern: AssertedPattern
	
	/// The direction from the input position onwards in which the asserted pattern must match for the assertion to hold.
	public var direction: MatchingDirection
	
}

extension Assertion : Pattern {
	
	public func matches(base: Match<AssertedPattern.Collection>, direction: MatchingDirection) -> AnyIterator<Match<AssertedPattern.Collection>> {
		unimplemented	// TODO
	}
	
}
