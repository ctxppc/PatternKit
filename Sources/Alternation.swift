// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches two patterns separately.
public struct Alternation<MainPattern : Pattern, AlternativePattern : Pattern> where
	MainPattern.Subject == AlternativePattern.Subject,
	MainPattern.ForwardMatchCollection.Iterator.Element == Match<MainPattern.Subject>,
	MainPattern.BackwardMatchCollection.Iterator.Element == Match<MainPattern.Subject>,
	AlternativePattern.ForwardMatchCollection.Iterator.Element == Match<AlternativePattern.Subject>,
	AlternativePattern.BackwardMatchCollection.Iterator.Element == Match<AlternativePattern.Subject> {	// TODO: Update constraints after updating constraints in match collection type, in Swift 4
	
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
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> ForwardAlternationMatchCollection<MainPattern, AlternativePattern> {
		return ForwardAlternationMatchCollection(mainPattern: mainPattern, alternativePattern: alternativePattern, baseMatch: base)
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> BackwardAlternationMatchCollection<MainPattern, AlternativePattern> {
		return BackwardAlternationMatchCollection(mainPattern: mainPattern, alternativePattern: alternativePattern, baseMatch: base)
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: MainPattern.Subject.Index) -> MainPattern.Subject.Index {
		return min(mainPattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition), alternativePattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition))
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: MainPattern.Subject.Index) -> MainPattern.Subject.Index {
		return max(mainPattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition), alternativePattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition))
	}
	
}

private enum Iterator<Collection : BidirectionalCollection> {
	case initial
	case matchingFirstPattern(iterator: AnyIterator<Match<Collection>>)
	case matchingSecondPattern(iterator: AnyIterator<Match<Collection>>)
	case done
}
