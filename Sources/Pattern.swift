// PatternKit © 2017 Constantino Tsarouhas

/// A description of a subsequence within a sequence.
///
/// Given a sequence and an input position, a pattern can determine a subsequence within the sequence, starting from the input position which is said to conform or **match** the pattern. Moreover, a pattern can determine any number of possible subsequences, including none.
///
/// To conform to this protocol, implement the `matchStates(entryState:)` method which takes a match state and generates some number of successor states. A match state encapsulates a current state in the pattern matching routine; successor states are all possible match states that result after `self` has performed pattern matching.
///
/// Most clients of patterns should use the convenience methods `matches(in:)`, `firstMatch(in:)`, or `hasMatches(in:)` which as a bonus perform some optimisations.
public protocol Pattern {
	
	/// The collection type on which pattern matching is performed.
	associatedtype Collection : BidirectionalCollection /* where Collection.Iterator.Element : Equatable */		// TODO: Add in Swift 4
	
	/// The iterator type for matches.
//	associatedtype MatchIterator : IteratorProtocol where MatchIterator.Element == Match<Collection>			// TODO: Add in Swift 4
	
	/// Returns an iterator of matches that result from performing matching.
	///
	/// - Parameter base: The match on which to base successor matches.
	/// - Parameter direction: The direction of matching.
	///
	/// - Returns: An iterator of matches. Every returned match must have the same `matchingCollection` as `origin.matchingCollection`.
	func matches(base: Match<Collection>, direction: MatchingDirection) -> AnyIterator<Match<Collection>>		// TODO: Remove in Swift 4
//	func matches(base: Match<Collection>, direction: MatchingDirection) -> MatchIterator						// TODO: Add in Swift 4
	
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
			.matches(base: Match(for: self), direction: .forward)
			.lazy
			.filter { candidateMatch in candidateMatch.remainingElements(direction: .forward).isEmpty }
	}
		
}

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
			.matches(base: Match(for: self.characters), direction: .forward)
			.lazy
			.filter { candidateMatch in candidateMatch.remainingElements(direction: .forward).isEmpty }
	}
	
}
