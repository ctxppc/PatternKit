// PatternKit © 2017 Constantino Tsarouhas

/// A type-erased pattern on `Collection`.
///
/// This pattern forwards its `matches(proceedingFrom:)` method to an arbitrary, underlying pattern on `Collection`, hiding the specifics of the underlying `Pattern` conformance.
///
/// Type-erased patterns are useful in dynamic contexts, e.g., when patterns are formed at runtime by an end user. Typed patterns (with typed subpatterns and so on) may be more efficient as they present optimisation opportunities for the compiler.
public struct AnyPattern<Collection : BidirectionalCollection> where Collection.Iterator.Element : Equatable {
	
	/// Creates a type-erased container for a given pattern.
	///
	/// - Parameter pattern: The pattern
	public init<PatternType : Pattern>(_ pattern: PatternType) where PatternType.Collection == Collection {
		matchGenerator = PatternType.matches(base:direction:)(pattern)
		self.pattern = pattern
	}
	
	/// A generator of iterators, given a base match and direction.
	fileprivate let matchGenerator: (Match<Collection>, MatchingDirection) -> AnyIterator<Match<Collection>>
	
	/// The type-erased pattern.
	///
	/// Clients can add type information back by casting it (conditionally) to a reified type, e.g., `pattern as? LiteralPattern<String.CharacterView>`.
	public let pattern: Any
	
}

extension AnyPattern : Pattern {
	
	public func matches(base: Match<Collection>, direction: MatchingDirection) -> AnyIterator<Match<Collection>> {
		return matchGenerator(base, direction)
	}
	
}
