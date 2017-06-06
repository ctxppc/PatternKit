// PatternKit © 2017 Constantino Tsarouhas

/// A description of a subsequence within a sequence.
///
/// Given a sequence and an input position, a pattern can determine a subsequence within the sequence, starting from the input position which is said to conform or **match** the pattern. Moreover, a pattern can determine any number of possible subsequences, including none.
///
/// To conform to this protocol, implement the `matchStates(base:direction:)` method which takes a match state and generates some number of successor states. A match state encapsulates a current state in the pattern matching routine; successor states are all possible match states that result after `self` has performed pattern matching.
///
/// Most clients of patterns should use the convenience methods `matches(_:)` and `matches(for:)` on the subject collection, passing the pattern as an argument.
public protocol Pattern {
	
	/// The collection type on which pattern matching is performed.
	associatedtype Subject : BidirectionalCollection /* where Subject.Iterator.Element : Equatable */							// TODO: Add constraint in Swift 4
	
	/// The collection type for matches.
	associatedtype MatchCollection : BidirectionalCollection /* where MatchCollection.Iterator.Element == Match<Subject> */		// TODO: Add constraint in Swift 4
	
	/// Returns a collection of matches over a subject, given a base match and a direction.
	///
	/// - Parameter base: The match on which to base successor matches.
	/// - Parameter direction: The direction of matching.
	///
	/// - Returns: A collection of matches over the subject in `base`, starting from the input position of `base`, and matching in the direction given by `direction`.
	func matches(base: Match<Subject>, direction: MatchingDirection) -> MatchCollection
	
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
	func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index
	
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
	func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index
	
}

extension Pattern {
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return inputPosition
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return inputPosition
	}
	
}
