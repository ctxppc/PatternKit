// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches two patterns sequentially.
public struct Concatenation<LeadingPattern : Pattern, TrailingPattern : Pattern> where
	LeadingPattern.Subject == TrailingPattern.Subject,
	LeadingPattern.MatchCollection.Iterator.Element == Match<LeadingPattern.Subject>,
	TrailingPattern.MatchCollection.Iterator.Element == Match<TrailingPattern.Subject>{
	
	public typealias Subject = LeadingPattern.Subject
	
	/// Creates a concatenated pattern.
	///
	/// - Parameter leadingPattern: The pattern that matches the first part of the concatenation.
	/// - Parameter trailingPattern: The pattern that matches the part after the part matched by the leading pattern.
	public init(_ leadingPattern: LeadingPattern, _ trailingPattern: TrailingPattern) {
		self.leadingPattern = leadingPattern
		self.trailingPattern = trailingPattern
	}
	
	/// The pattern that matches the first part of the concatenation.
	public var leadingPattern: LeadingPattern
	
	/// The pattern that matches the part after the part matched by the leading pattern.
	public var trailingPattern: TrailingPattern
	
}

extension Concatenation : Pattern {
	
	public typealias MatchCollection = ConcatenationMatchCollection<LeadingPattern, TrailingPattern>
	
	public func matches(base: Match<Subject>, direction: MatchingDirection) -> AnyBidirectionalCollection<Match<Subject>> {		// TODO: Remove in Swift 4, after removing requirement in Pattern
		return AnyBidirectionalCollection(matches(base: base, direction: direction) as ConcatenationMatchCollection)
	}
	
	public func matches(base: Match<Subject>, direction: MatchingDirection) -> ConcatenationMatchCollection<LeadingPattern, TrailingPattern> {
		return ConcatenationMatchCollection(leadingPattern: leadingPattern, trailingPattern: trailingPattern, baseMatch: base, direction: direction)
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return leadingPattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return trailingPattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition)
	}
	
}
