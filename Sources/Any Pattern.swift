// PatternKit © 2017 Constantino Tsarouhas

/// A type-erased pattern on `Collection`.
///
/// This pattern forwards its `matches(base:direction:)` method to an arbitrary, underlying pattern on `Collection`, hiding the specifics of the underlying `Pattern` conformance.
///
/// Type-erased patterns are useful in dynamic contexts, e.g., when patterns are formed at runtime by an end user. Typed patterns (with typed subpatterns and so on) may be more efficient as they present optimisation opportunities to the compiler.
public struct AnyPattern<Subject : BidirectionalCollection> where Subject.Iterator.Element : Equatable {
	
	/// Creates a type-erased container for a given pattern.
	///
	/// - Parameter pattern: The pattern
	public init<P : Pattern>(_ pattern: P) where
		P.Subject == Subject,
		P.MatchCollection.Iterator.Element == Match<P.Subject>,
		P.MatchCollection.Indices : BidirectionalCollection,
		P.MatchCollection.SubSequence : BidirectionalCollection,
		P.MatchCollection.Indices.Index == P.MatchCollection.Index,
		P.MatchCollection.Indices.SubSequence == P.MatchCollection.Indices,
		P.MatchCollection.Indices.Iterator.Element == P.MatchCollection.Index,
		P.MatchCollection.SubSequence.Index == P.MatchCollection.Index,
		P.MatchCollection.SubSequence.Indices : BidirectionalCollection,
		P.MatchCollection.SubSequence.SubSequence == P.MatchCollection.SubSequence,
		P.MatchCollection.SubSequence.Indices.Index == P.MatchCollection.Index,
		P.MatchCollection.SubSequence.Indices.SubSequence == P.MatchCollection.SubSequence.Indices,
		P.MatchCollection.SubSequence.Iterator.Element == Match<P.Subject>,
		P.MatchCollection.SubSequence.Indices.Iterator.Element == P.MatchCollection.Index {		// TODO: Remove constraints when they're added to BidirectionalCollection, in Swift 4
		
		matchCollectionGenerator = { base, direction in
			AnyBidirectionalCollection(pattern.matches(base: base, direction: direction))
		}
		
		forwardEstimator = P.underestimatedSmallestInputPositionForForwardMatching(pattern)
		backwardEstimator = P.overestimatedLargestInputPositionForBackwardMatching(pattern)
		self.pattern = pattern
		
	}
	
	/// A generator of match collections, given a base match and direction.
	fileprivate let matchCollectionGenerator: (Match<Subject>, MatchingDirection) -> AnyBidirectionalCollection<Match<Subject>>
	
	/// The underestimator heuristic function of the pattern.
	fileprivate let forwardEstimator: (Subject, Subject.Index) -> Subject.Index
	
	/// The underestimator heuristic function of the pattern.
	fileprivate let backwardEstimator: (Subject, Subject.Index) -> Subject.Index
	
	/// The type-erased pattern.
	///
	/// Clients can add type information back by casting `pattern` to a reified type, e.g., `pattern as? LiteralPattern<String.CharacterView>`.
	public let pattern: Any
	
}

extension AnyPattern : Pattern {
	
	public func matches(base: Match<Subject>, direction: MatchingDirection) -> AnyBidirectionalCollection<Match<Subject>> {
		return matchCollectionGenerator(base, direction)
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return forwardEstimator(subject, inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return backwardEstimator(subject, inputPosition)
	}
	
}
