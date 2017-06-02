// PatternKit © 2017 Constantino Tsarouhas

extension String {
	
	/// Returns a Boolean value indicating whether the string matches a pattern.
	///
	/// - Complexity: O(b^d) where *b* is the length of the largest sequential subpattern and *d* is the largest depth of recursion.
	///
	/// - Parameter pattern: The pattern to match against.
	///
	/// - Returns: `true` if `self` matches `pattern`.
	public func matches<P : Pattern>(_ pattern: P) -> Bool where P.Subject == CharacterView, P.MatchCollection.Iterator.Element == Match<CharacterView> {
		return characters.matches(pattern)
	}
	
	/// Returns a lazily computed collection of matches of a pattern over the string.
	///
	/// - Complexity: O(1) for making the collection; O(b^d) for iterating over it, where *b* is the length of the largest sequential subpattern and *d* is the largest depth of recursion.
	///
	/// - Parameter pattern: The pattern to match against.
	///
	/// - Returns: A lazily computed collection of matches of `pattern` over `self`.
	public func matches<P : Pattern>(for pattern: P) -> LazyFilterBidirectionalCollection<P.MatchCollection> where P.Subject == CharacterView, P.MatchCollection.Iterator.Element == Match<CharacterView> {
		return characters.matches(for: pattern)
	}
	
}
