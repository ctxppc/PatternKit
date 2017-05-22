// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches an exact subcollection.
public struct Literal<Collection : BidirectionalCollection> where
	Collection.Iterator.Element : Equatable,
	Collection.Iterator.Element == Collection.SubSequence.Iterator.Element,
	Collection.IndexDistance == Collection.SubSequence.IndexDistance,
	Collection.SubSequence : BidirectionalCollection {
	
	/// Creates a pattern that matches an exact collection.
	///
	/// - Parameter literal: The collection that the pattern matches exactly.
	public init(_ literal: Collection) {
		self.literal = literal
	}
	
	/// The collection that the pattern matches exactly.
	public var literal: Collection
	
}

extension Literal : Pattern {
	
	public func matches(base: Match<Collection>, direction: MatchingDirection) -> AnyIterator<Match<Collection>> {
		
		switch direction {
			case .forward:	guard base.remainingElements(direction: .forward).starts(with: literal) else { return none() }
			case .backward:	guard base.remainingElements(direction: .forward).ends(with: literal) else { return none() }
		}
		
		return one(base.movingInputPosition(distance: literal.count, direction: direction))
		
	}
	
	// TODO: Implement heuristics.
	
}
