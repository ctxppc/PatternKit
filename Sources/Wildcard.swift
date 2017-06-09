// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches any one element.
public struct Wildcard<Subject : BidirectionalCollection> where Subject.Iterator.Element : Equatable {}

extension Wildcard : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> SingularMatchCollection<Subject> {
		guard !base.remainingElements(direction: .forward).isEmpty else { return nil }
		return SingularMatchCollection(resultMatch: base.movingInputPosition(distance: 1, direction: .forward))
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> SingularMatchCollection<Subject> {
		guard !base.remainingElements(direction: .backward).isEmpty else { return nil }
		return SingularMatchCollection(resultMatch: base.movingInputPosition(distance: 1, direction: .backward))
	}
	
}

/// Returns a pattern matching exactly one element.
///
/// - Returns: `Wildcard()`
public func one<C>() -> Wildcard<C> {
	return Wildcard()
}

/// Returns a pattern matching some number of arbitrary elements.
///
/// - Parameter lowerBound: The lower bound. The default is zero.
/// - Parameter upperBound: The upper bound, inclusive. The default is `Int.max`.
/// - Parameter tendency: The tendency to match as few or as many arbitrary elements as possible. The default is eager matching.
///
/// - Returns: `Repeating(Wildcard(), min: lowerBound, max: upperBound, tendency: tendency)`
public func any<C>(min lowerBound: Int = 0, max upperBound: Int = .max, tendency: Repeating<Wildcard<C>>.Tendency = .eager) -> Repeating<Wildcard<C>> {
	return Repeating(Wildcard(), min: lowerBound, max: upperBound, tendency: tendency)
}
