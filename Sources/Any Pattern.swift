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
	public init<PatternType : Pattern>(_ pattern: PatternType) where PatternType.Subject == Subject {
		matchCollectionGenerator = PatternType.matches(base:direction:)(pattern)
		forwardEstimator = PatternType.underestimatedSmallestInputPositionForForwardMatching(pattern)
		backwardEstimator = PatternType.overestimatedLargestInputPositionForBackwardMatching(pattern)
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
	
	public typealias MatchCollection = AnyBidirectionalCollection<Match<Subject>>
	
	public func matches(base: Match<Subject>, direction: MatchingDirection) -> AnyBidirectionalCollection<Match<Subject>> {
		return matchCollectionGenerator(base, direction)	// TODO: Reimplement using associated type in Swift 4
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return forwardEstimator(subject, inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return backwardEstimator(subject, inputPosition)
	}
	
}
