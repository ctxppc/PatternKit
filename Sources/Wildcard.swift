// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches any one element.
public struct Wildcard<Collection : BidirectionalCollection> where Collection.Iterator.Element : Equatable {}

extension Wildcard : Pattern {
	
	public func matches(base: Match<Collection>, direction: MatchingDirection) -> AnyIterator<Match<Collection>> {
		guard !base.remainingElements(direction: direction).isEmpty else { return none() }
		return one(base.movingInputPosition(distance: 1, direction: direction))
	}
	
}
