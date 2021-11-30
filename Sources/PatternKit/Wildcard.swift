// PatternKit © 2017–21 Constantino Tsarouhas

/// A pattern that matches any one element.
public struct Wildcard<Subject : BidirectionalCollection> where Subject.Element : Equatable {}

extension Wildcard : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> SingularMatchCollection<Subject> {
		guard !base.remainingElements(direction: .forward).isEmpty else { return nil }
		return .init(resultMatch: base.movingInputPosition(distance: 1, direction: .forward))
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> SingularMatchCollection<Subject> {
		guard !base.remainingElements(direction: .backward).isEmpty else { return nil }
		return .init(resultMatch: base.movingInputPosition(distance: 1, direction: .backward))
	}
	
}

/// Returns a pattern matching exactly one element.
///
/// - Returns: `Wildcard()`
public func one<C>() -> Wildcard<C> {
	.init()
}

/// Returns a pattern eagerly matching some number of arbitrary elements.
///
/// - Parameter lowerBound: The lower bound. The default is zero.
/// - Parameter upperBound: The upper bound, inclusive. The default is `Int.max`.
///
/// - Returns: A pattern eagerly matching some number of arbitrary elements.
public func any<C>(min lowerBound: Int = 0, max upperBound: Int = .max) -> EagerlyRepeating<Wildcard<C>> {
	.init(Wildcard(), min: lowerBound, max: upperBound)
}
