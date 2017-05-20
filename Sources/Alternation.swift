// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches two patterns separately.
public struct Alternation<MainPattern : Pattern, AlternativePattern : Pattern> where MainPattern.Collection == AlternativePattern.Collection {
	
	/// Creates a pattern that matches two patterns separately and sequentially.
	///
	/// - Parameter mainPattern: The pattern whose matches are generated first.
	/// - Parameter alternativePattern: The pattern whose matches are generated after those of the main pattern.
	public init(_ mainPattern: MainPattern, _ alternativePattern: AlternativePattern) {
		self.mainPattern = mainPattern
		self.alternativePattern = alternativePattern
	}
	
	/// The pattern whose matches are generated first.
	public var mainPattern: MainPattern
	
	/// The pattern whose matches are generated after those of the main pattern.
	public var alternativePattern: AlternativePattern
	
}

extension Alternation : Pattern {
	
	public typealias Collection = MainPattern.Collection
	
	public func matches(base: Match<Collection>, direction: MatchingDirection) -> AnyIterator<Match<Collection>> {
		
		func makeIterator<A : Pattern, B : Pattern>(firstPattern: A, secondPattern: B) -> AnyIterator<Match<Collection>> where A.Collection == Collection, B.Collection == Collection {
			
			var state = Iterator<Collection>.initial
			func next() -> Match<Collection>? {
				switch state {
					
					case .initial:
					state = .matchingFirstPattern(iterator: firstPattern.matches(base: base, direction: direction))
					return next()
					
					case .matchingFirstPattern(iterator: let iterator):
					if let match = iterator.next() {
						return match
					} else {
						state = .matchingSecondPattern(iterator: secondPattern.matches(base: base, direction: direction))
						return next()
					}
					
					case .matchingSecondPattern(iterator: let iterator):
					if let match = iterator.next() {
						return match
					} else {
						state = .done
						return next()
					}
					
					case .done:
					return nil
					
				}
			}
			
			return AnyIterator(next)
			
		}
		
		switch direction {
			case .forward:	return makeIterator(firstPattern: mainPattern, secondPattern: alternativePattern)
			case .backward:	return makeIterator(firstPattern: alternativePattern, secondPattern: mainPattern)
		}
		
	}
	
}

private enum Iterator<Collection : BidirectionalCollection> {
	case initial
	case matchingFirstPattern(iterator: AnyIterator<Match<Collection>>)
	case matchingSecondPattern(iterator: AnyIterator<Match<Collection>>)
	case done
}
