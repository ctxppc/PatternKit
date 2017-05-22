// PatternKit © 2017 Constantino Tsarouhas

extension RangeReplaceableCollection {
	
	/// Returns a copy of the collection with the contents of a given sequence appended to it.
	///
	/// - Parameter other: The sequence whose elements to append.
	///
	/// - Returns: A copy of the collection with the contents of `other` appended to it.
	func appending<S : Sequence>(contentsOf other: S) -> Self where S.Iterator.Element == Iterator.Element {
		return withCopy(of: self, mutator: Self.append, argument: other)
	}
	
}

extension BidirectionalCollection where Iterator.Element : Equatable {
	
	/// Returns a Boolean value indicating whether the collection matches a pattern.
	///
	/// - Complexity: O(b^d) where *b* is the length of the largest sequential subpattern and *d* is the largest depth of recursion.
	///
	/// - Parameter pattern: The pattern to match against.
	///
	/// - Returns: `true` if `self` matches `pattern`.
	public func matches<P : Pattern>(_ pattern: P) -> Bool where P.Collection == Self {
		return matches(for: pattern).first() != nil
	}
	
	/// Returns a lazily computed sequence of matches of a pattern over the collection.
	///
	/// - Complexity: O(1) for making the sequence; O(b^d) for iterating over it, where *b* is the length of the largest sequential subpattern and *d* is the largest depth of recursion.
	///
	/// - Parameter pattern: The pattern to match against.
	///
	/// - Returns: A lazily computed sequence of matches of `pattern` over `self`.
	public func matches<P : Pattern>(for pattern: P) -> LazyFilterSequence<AnyIterator<Match<Self>>> where P.Collection == Self {
		return pattern
			.matches(base: Match(on: self), direction: .forward)
			.lazy
			.filter { candidateMatch in candidateMatch.remainingElements(direction: .forward).isEmpty }
	}
	
	/// Returns a Boolean value indicating whether the collection's last elements are the same as the elements from another collection.
	///
	/// - Parameter suffix: The elements.
	///
	/// - Returns: `true` if the last elements in `self` are `suffix`, otherwise `false`.
	func ends<Suffix : BidirectionalCollection>(with suffix: Suffix) -> Bool where Suffix.Iterator.Element == Self.Iterator.Element, Suffix.IndexDistance == Self.IndexDistance {
		
		guard self.count >= suffix.count else { return false }
		
		for (element1, element2) in zip(suffix.reversed(), self.reversed()) {
			guard element1 == element2 else { return false }
		}
		
		return true
		
	}
	
}
