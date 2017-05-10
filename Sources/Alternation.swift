// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches any one of two patterns.
public struct Alternation<MainPattern : Pattern, AlternativePattern : Pattern> where MainPattern.Collection == AlternativePattern.Collection {
	
	/// Creates an alternated pattern.
	///
	/// - Parameter leadingPattern: The pattern that matches the first part of the concatenation.
	/// - Parameter trailingPattern: The pattern that matches the part after the part matched by the leading pattern.
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
	
	public func matches(proceedingFrom origin: Match<Collection>) -> AnyIterator<Match<Collection>> {
		
		var state = Iterator<Collection>.initial
		func next() -> Match<Collection>? {
			switch state {
				
				case .initial:
				state = .matchingMainPattern(iterator: mainPattern.matches(proceedingFrom: origin))
				return next()
				
				case .matchingMainPattern(iterator: let iterator):
				if let match = iterator.next() {
					return match
				} else {
					state = .matchingAlternativePattern(iterator: alternativePattern.matches(proceedingFrom: origin))
					return next()
				}
				
				case .matchingAlternativePattern(iterator: let iterator):
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
	
}

private enum Iterator<Collection : BidirectionalCollection> {
	case initial
	case matchingMainPattern(iterator: AnyIterator<Match<Collection>>)
	case matchingAlternativePattern(iterator: AnyIterator<Match<Collection>>)
	case done
}

public func |<MainPattern : Pattern, AlternativePattern : Pattern>(l: MainPattern, r: AlternativePattern) -> Alternation<MainPattern, AlternativePattern> {
	return Alternation(l, r)
}
