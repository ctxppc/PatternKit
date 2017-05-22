// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches two patterns sequentially.
public struct Concatenation<LeadingPattern : Pattern, TrailingPattern : Pattern> where LeadingPattern.Collection == TrailingPattern.Collection {
	
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
	
	public typealias Collection = LeadingPattern.Collection
	
	public func matches(base: Match<Collection>, direction: MatchingDirection) -> AnyIterator<Match<Collection>> {
		
		func makeIterator<A : Pattern, B : Pattern>(firstPattern: A, secondPattern: B) -> AnyIterator<Match<Collection>> where A.Collection == Collection, B.Collection == Collection {
			
			var iteratorOfFirstPattern = firstPattern.matches(base: base, direction: direction)
			guard let firstMatchForFirstPattern = iteratorOfFirstPattern.next() else { return none() }
			var matchForFirstPattern = firstMatchForFirstPattern
			
			func makeIteratorOfSecondPattern() -> AnyIterator<Match<Collection>> {
				return secondPattern.matches(base: matchForFirstPattern, direction: direction)
			}
			var iteratorOfSecondPattern = makeIteratorOfSecondPattern()
			
			func next() -> Match<Collection>? {
				if let matchForSecondPattern = iteratorOfSecondPattern.next() {				// Next match in second pattern found
					return matchForSecondPattern
				} else if let nextMatchForFirstPattern = iteratorOfFirstPattern.next() {	// Next match in first pattern found
					matchForFirstPattern = nextMatchForFirstPattern
					iteratorOfSecondPattern = makeIteratorOfSecondPattern()
					return next()
				} else {																	// Both patterns exhausted
					return nil
				}
			}
			
			return AnyIterator(next)
			
		}
		
		switch direction {
			case .forward:	return makeIterator(firstPattern: leadingPattern, secondPattern: trailingPattern)
			case .backward:	return makeIterator(firstPattern: trailingPattern, secondPattern: leadingPattern)
		}
		
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: LeadingPattern.Collection, fromIndex inputPosition: LeadingPattern.Collection.Index) -> LeadingPattern.Collection.Index {
		return leadingPattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: TrailingPattern.Collection, fromIndex inputPosition: TrailingPattern.Collection.Index) -> TrailingPattern.Collection.Index {
		return trailingPattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition)
	}
	
}
