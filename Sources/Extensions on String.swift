// PatternKit © 2017 Constantino Tsarouhas

extension String {
	
	/// Returns a Boolean value indicating whether the string matches a pattern.
	///
	/// - Complexity: O(b^d) where *b* is the length of the largest sequential subpattern and *d* is the largest depth of recursion.
	///
	/// - Parameter pattern: The pattern to match against.
	///
	/// - Returns: `true` if `self` matches `pattern`.
	public func matches<P : Pattern>(_ pattern: P) -> Bool where P.Collection == CharacterView {
		return matches(for: pattern).first() != nil
	}
	
	/// Returns a lazily computed sequence of matches of a pattern over the string.
	///
	/// - Complexity: O(1) for making the sequence; O(b^d) for iterating over it, where *b* is the length of the largest sequential subpattern and *d* is the largest depth of recursion.
	///
	/// - Parameter pattern: The pattern to match against.
	///
	/// - Returns: A lazily computed sequence of matches of `pattern` over `self`.
	public func matches<P : Pattern>(for pattern: P) -> LazyFilterSequence<AnyIterator<Match<CharacterView>>> where P.Collection == CharacterView {
		return pattern
			.matches(base: Match(on: self.characters), direction: .forward)
			.lazy
			.filter { candidateMatch in candidateMatch.remainingElements(direction: .forward).isEmpty }
	}
	
}
