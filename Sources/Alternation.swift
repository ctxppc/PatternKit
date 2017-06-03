// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches two patterns separately.
public struct Alternation<MainPattern : Pattern, AlternativePattern : Pattern> where
	MainPattern.Subject == AlternativePattern.Subject,
	MainPattern.MatchCollection.Iterator.Element == Match<MainPattern.Subject>,
	AlternativePattern.MatchCollection.Iterator.Element == Match<AlternativePattern.Subject> {	// TODO: Update constraints after updating constraints in match collection type, in Swift 4
	
	public typealias Subject = MainPattern.Subject
	
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
	
	public typealias MatchCollection = AlternationMatchCollection<MainPattern, AlternativePattern>
	
	public func matches(base: Match<Subject>, direction: MatchingDirection) -> AnyBidirectionalCollection<Match<Subject>> {		// TODO: Remove in Swift 4, after removing requirement in Pattern
		return AnyBidirectionalCollection(matches(base: base, direction: direction) as AlternationMatchCollection)
	}
	
	public func matches(base: Match<Subject>, direction: MatchingDirection) -> AlternationMatchCollection<MainPattern, AlternativePattern> {
		return AlternationMatchCollection(mainPattern: mainPattern, alternativePattern: alternativePattern, baseMatch: base, direction: direction)
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: MainPattern.Subject, fromIndex inputPosition: MainPattern.Subject.Index) -> MainPattern.Subject.Index {
		return min(mainPattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition), alternativePattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition))
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: MainPattern.Subject, fromIndex inputPosition: MainPattern.Subject.Index) -> MainPattern.Subject.Index {
		return max(mainPattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition), alternativePattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition))
	}
	
}

private enum Iterator<Collection : BidirectionalCollection> {
	case initial
	case matchingFirstPattern(iterator: AnyIterator<Match<Collection>>)
	case matchingSecondPattern(iterator: AnyIterator<Match<Collection>>)
	case done
}
