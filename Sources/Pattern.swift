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
	/// - Returns: An iterator of matches. Every returned match must have the same `subject` as `base`.
	func matches(base: Match<Collection>, direction: MatchingDirection) -> AnyIterator<Match<Collection>>		// TODO: Remove in Swift 4
//	func matches(base: Match<Collection>, direction: MatchingDirection) -> MatchIterator						// TODO: Add in Swift 4
	
	/// Determines the smallest index in `subject` equal to or greater than `inputPosition` that can be passed to `matches(base:direction:)`, in the context of forward matching.
	///
	/// This method may be used to quickly determine a start index for a match and thus skip ineligible parts of a collection. As an optimisation, it may underestimate and must not overestimate.
	///
	/// The default implementation returns `inputPosition`.
	///
	/// - Requires: `inputPosition` is a valid index into `subject`.
	///
	/// - Invariant: Every input position between `inputPosition` and this method's result value (the latter itself excluded) results in no matches being produced.
	///
	/// - Complexity: *O(n)*, where *n* is the length of the collection.
	///
	/// - Parameter subject: The collection on which the pattern is to be applied.
	/// - Parameter inputPosition: The input position within the collection from where forward matching starts.
	///
	/// - Returns: The smallest index in `subject` equal to or greater than `inputPosition` that may result in matches. If the pattern cannot possibly generate matches from `inputPosition` onward, `subject.endIndex` may be returned.
	func underestimatedSmallestInputPositionForForwardMatching(on subject: Collection, fromIndex inputPosition: Collection.Index) -> Collection.Index
	
	/// Determines the largest index in `subject` equal to or smaller than `inputPosition` that can be passed to `matches(base:direction:)`, in the context of backward matching.
	///
	/// This method may be used to quickly determine a start index for a match and thus skip ineligible parts of a collection. As an optimisation, it may overestimate and must not underestimate.
	///
	/// The default implementation returns `inputPosition`.
	///
	/// - Requires: `inputPosition` is a valid index into `subject`.
	///
	/// - Invariant: Every input position between this method's result value and `inputPosition` (the latter itself excluded) results in no matches being produced.
	///
	/// - Complexity: *O(n)*, where *n* is the length of the collection.
	///
	/// - Parameter subject: The collection on which the pattern is to be applied.
	/// - Parameter inputPosition: The input position within the collection from where backward matching starts.
	///
	/// - Returns: The smallest index in `subject` equal to or smaller than `inputPosition` that may result in matches. If the pattern cannot possibly generate matches between `inputPosition` and `subject.startIndex`, `subject.startIndex` may be returned.
	func overestimatedLargestInputPositionForBackwardMatching(on subject: Collection, fromIndex inputPosition: Collection.Index) -> Collection.Index
	
}

extension Pattern {
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Collection, fromIndex inputPosition: Collection.Index) -> Collection.Index {
		return inputPosition
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Collection, fromIndex inputPosition: Collection.Index) -> Collection.Index {
		return inputPosition
	}
	
}
