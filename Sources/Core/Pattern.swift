// PatternKit © 2017–19 Constantino Tsarouhas

/// A description of a subsequence within a sequence.
///
/// Given a sequence and an input position, a pattern can determine a subsequence within the sequence, starting from the input position which is said to conform or **match** the pattern. Moreover, a pattern can determine any number of possible subsequences, including none.
///
/// To conform to this protocol, implement the `forwardMatches(enteringFrom:)` and `backwardMatches(recedingFrom:)` methods which take a base match and generate some number of successor matches. A match encapsulates a current state in the pattern matching routine; successor matches are all possible states that result after `self` has performed pattern matching.
///
/// Most clients of patterns should use the convenience methods `matches(over:)` and `hasMatches(over:)`.
public protocol Pattern {
	
	/// The type of the collections over which pattern matching is performed.
	associatedtype Subject : BidirectionalCollection where Subject.Element : Equatable
	
	/// The type for collections of matches generated by patterns during forward matching.
	associatedtype ForwardMatchCollection : BidirectionalCollection where ForwardMatchCollection.Element == Match<Subject>
	
	/// The type for collections of matches generated by patterns during backward matching.
	associatedtype BackwardMatchCollection : BidirectionalCollection where BackwardMatchCollection.Element == Match<Subject>
	
	/// Returns a (typically lazily computed) collection of forward matches over a subject.
	///
	/// - Parameter base: The match from where to start matching.
	///
	/// - Returns: A (typically lazily computed) collection of forward matches over the subject in `base`, between the input position of `base` and the end index of the subject noninclusive.
	func forwardMatches(enteringFrom base: Match<Subject>) -> ForwardMatchCollection
	
	/// Returns a (typically lazily computed) collection of backward matches over a subject.
	///
	/// - Parameter base: The match from where to start matching.
	///
	/// - Returns: A (typically lazily computed) collection of backward matches over the subject in `base`, between the start index of the subject and the input position of `base` noninclusive.
	func backwardMatches(recedingFrom base: Match<Subject>) -> BackwardMatchCollection
	
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
	
	/// Returns a lazily computed collection of forward matches over some subject that match the subject wholly.
	///
	/// - Complexity: O(1) to create the collection; O(b^d) to traverse it completely, where *b* is the length of the largest sequential subpattern and *d* is the largest depth of recursion.
	///
	/// - Parameter subject: The collection over which to match the pattern.
	///
	/// - Returns: A lazily computed collection of forward matches of `self` over `subject`.
	public func matches(over subject: Subject) -> LazyFilterCollection<ForwardMatchCollection> {
		return forwardMatches(enteringFrom: Match(over: subject, direction: .forward))
			.lazy
			.filter { candidateMatch in candidateMatch.remainingElements(direction: .forward).isEmpty }
	}
	
	/// Returns a lazily computed collection of backward matches over some subject that match the subject wholly.
	///
	/// - Complexity: O(1) to create the collection; O(b^d) to traverse it completely, where *b* is the length of the largest sequential subpattern and *d* is the largest depth of recursion.
	///
	/// - Parameter subject: The collection over which to match the pattern.
	///
	/// - Returns: A lazily computed collection of backward matches of `self` over `subject`.
	public func backwardMatches(over subject: Subject) -> LazyFilterCollection<BackwardMatchCollection> {
		return backwardMatches(recedingFrom: Match(over: subject, direction: .backward))
			.lazy
			.filter { candidateMatch in candidateMatch.remainingElements(direction: .backward).isEmpty }
	}
	
	/// Returns a Boolean value indicating whether the pattern matches some subject wholly.
	///
	/// - Complexity: O(b^d) where *b* is the length of the largest sequential subpattern and *d* is the largest depth of recursion.
	///
	/// - Parameter subject: The collection over which to match the pattern.
	/// - Parameter direction: The direction in which to perform the matching. The default is forward matching. In some cases, backward matching may be more efficient.
	///
	/// - Returns: `true` if there is at least one match of `self` over `subject`; `false` otherwise.
	public func hasMatches(over subject: Subject, direction: MatchingDirection = .forward) -> Bool {
		switch direction {
			case .forward:	return !matches(over: subject).isEmpty
			case .backward:	return !backwardMatches(over: subject).isEmpty
		}
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return inputPosition
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return inputPosition
	}
	
}
