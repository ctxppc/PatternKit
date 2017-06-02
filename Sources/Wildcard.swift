// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches any one element.
public struct Wildcard<Subject : BidirectionalCollection> where Subject.Iterator.Element : Equatable {}

extension Wildcard : Pattern {
	
	public typealias MatchCollection = SingularMatchCollection<Subject>
	
	public func matches(base: Match<Subject>, direction: MatchingDirection) -> AnyBidirectionalCollection<Match<Subject>> {		// TODO: Remove in Swift 4, after removing requirement in Pattern
		return AnyBidirectionalCollection(matches(base: base, direction: direction) as SingularMatchCollection)
	}
	
	public func matches(base: Match<Subject>, direction: MatchingDirection) -> SingularMatchCollection<Subject> {
		guard !base.remainingElements(direction: direction).isEmpty else { return nil }
		return SingularMatchCollection(resultMatch: base.movingInputPosition(distance: 1, direction: direction))
	}
	
}

/// Returns a pattern matching exactly one element.
///
/// - Returns: `Wildcard()`
public func one<C>() -> Wildcard<C> {
	return Wildcard()
}

// TODO

///// Returns a pattern matching some number of arbitrary elements.
/////
///// - Parameter lowerBound: The lower bound. The default is zero.
///// - Parameter upperBound: The upper bound, inclusive. The default is `Int.max`.
///// - Parameter tendency: The tendency to match as few or as many arbitrary elements as possible. The default is eager matching.
/////
///// - Returns: `Repeating(Wildcard(), min: lowerBound, max: upperBound, tendency: tendency)`
//public func any<C>(min lowerBound: Int = 0, max upperBound: Int = .max, tendency: Repeating<Wildcard<C>>.Tendency = .eager) -> Repeating<Wildcard<C>> {
//	return Repeating(Wildcard(), min: lowerBound, max: upperBound, tendency: tendency)
//}
