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
		
		P.ForwardMatchCollection.Iterator.Element == Match<P.Subject>,
		P.ForwardMatchCollection.Indices : BidirectionalCollection,
		P.ForwardMatchCollection.SubSequence : BidirectionalCollection,
		P.ForwardMatchCollection.Indices.Index == P.ForwardMatchCollection.Index,
		P.ForwardMatchCollection.Indices.SubSequence == P.ForwardMatchCollection.Indices,
		P.ForwardMatchCollection.Indices.Iterator.Element == P.ForwardMatchCollection.Index,
		P.ForwardMatchCollection.SubSequence.Index == P.ForwardMatchCollection.Index,
		P.ForwardMatchCollection.SubSequence.Indices : BidirectionalCollection,
		P.ForwardMatchCollection.SubSequence.SubSequence == P.ForwardMatchCollection.SubSequence,
		P.ForwardMatchCollection.SubSequence.Indices.Index == P.ForwardMatchCollection.Index,
		P.ForwardMatchCollection.SubSequence.Indices.SubSequence == P.ForwardMatchCollection.SubSequence.Indices,
		P.ForwardMatchCollection.SubSequence.Iterator.Element == Match<P.Subject>,
		P.ForwardMatchCollection.SubSequence.Indices.Iterator.Element == P.ForwardMatchCollection.Index,
		
		P.BackwardMatchCollection.Iterator.Element == Match<P.Subject>,
		P.BackwardMatchCollection.Indices : BidirectionalCollection,
		P.BackwardMatchCollection.SubSequence : BidirectionalCollection,
		P.BackwardMatchCollection.Indices.Index == P.BackwardMatchCollection.Index,
		P.BackwardMatchCollection.Indices.SubSequence == P.BackwardMatchCollection.Indices,
		P.BackwardMatchCollection.Indices.Iterator.Element == P.BackwardMatchCollection.Index,
		P.BackwardMatchCollection.SubSequence.Index == P.BackwardMatchCollection.Index,
		P.BackwardMatchCollection.SubSequence.Indices : BidirectionalCollection,
		P.BackwardMatchCollection.SubSequence.SubSequence == P.BackwardMatchCollection.SubSequence,
		P.BackwardMatchCollection.SubSequence.Indices.Index == P.BackwardMatchCollection.Index,
		P.BackwardMatchCollection.SubSequence.Indices.SubSequence == P.BackwardMatchCollection.SubSequence.Indices,
		P.BackwardMatchCollection.SubSequence.Iterator.Element == Match<P.Subject>,
		P.BackwardMatchCollection.SubSequence.Indices.Iterator.Element == P.BackwardMatchCollection.Index {		// TODO: Remove constraints when they're added to BidirectionalCollection, in Swift 4
		
		forwardMatchCollectionGenerator = { base in
			AnyBidirectionalCollection(pattern.forwardMatches(enteringFrom: base))
		}
			
		backwardMatchCollectionGenerator = { base in
			AnyBidirectionalCollection(pattern.backwardMatches(recedingFrom: base))
		}
		
		forwardEstimator = P.underestimatedSmallestInputPositionForForwardMatching(pattern)
		backwardEstimator = P.overestimatedLargestInputPositionForBackwardMatching(pattern)
		self.pattern = pattern
		
	}
	
	/// A generator of forward match collections, given a base match.
	fileprivate let forwardMatchCollectionGenerator: (Match<Subject>) -> AnyBidirectionalCollection<Match<Subject>>
	
	/// A generator of backward match collections, given a base match.
	fileprivate let backwardMatchCollectionGenerator: (Match<Subject>) -> AnyBidirectionalCollection<Match<Subject>>
	
	/// The underestimator heuristic function of the pattern for forward matching.
	fileprivate let forwardEstimator: (Subject, Subject.Index) -> Subject.Index
	
	/// The underestimator heuristic function of the pattern for backward matching.
	fileprivate let backwardEstimator: (Subject, Subject.Index) -> Subject.Index
	
	/// The type-erased pattern.
	///
	/// Clients can add type information back by casting `pattern` to a reified type, e.g., `pattern as? LiteralPattern<String.CharacterView>`.
	public let pattern: Any
	
}

extension AnyPattern : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> AnyBidirectionalCollection<Match<Subject>> {
		return forwardMatchCollectionGenerator(base)
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> AnyBidirectionalCollection<Match<Subject>> {
		return backwardMatchCollectionGenerator(base)
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return forwardEstimator(subject, inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return backwardEstimator(subject, inputPosition)
	}
	
}
