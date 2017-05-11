// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches any one element.
public struct Wildcard<Collection : BidirectionalCollection> where Collection.Iterator.Element : Equatable {}

extension Wildcard : Pattern {
	
	public func matches(proceedingFrom origin: Match<Collection>) -> AnyIterator<Match<Collection>> {
		guard !origin.indicesFollowingInputPosition.isEmpty else { return none() }
		return one(origin.movingInputPosition(distance: 1))
	}
	
}
