// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches two patterns sequentially.
public struct Concatenation<LeadingPattern : Pattern, TrailingPattern : Pattern> where LeadingPattern.Collection == TrailingPattern.Collection {
	
	public typealias Collection = LeadingPattern.Collection
	
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
	
	/// Returns a forward match iterator.
	///
	/// - Parameter base: The base match.
	///
	/// - Returns: A forward match iterator with base `base`.
	public func makeForwardMatchIterator(base: Match<Collection>) -> ConcatenationMatchIterator<LeadingPattern, TrailingPattern> {
		return ConcatenationMatchIterator(firstPattern: leadingPattern, secondPattern: trailingPattern, baseMatch: base, direction: .forward)
	}
	
	/// Returns a backward match iterator.
	///
	/// - Parameter base: The base match.
	///
	/// - Returns: A backward match iterator with base `base`.
	public func makeBackwardMatchIterator(base: Match<Collection>) -> ConcatenationMatchIterator<TrailingPattern, LeadingPattern> {
		return ConcatenationMatchIterator(firstPattern: trailingPattern, secondPattern: leadingPattern, baseMatch: base, direction: .backward)
	}
	
}

extension Concatenation : Pattern {
	
	public func matches(base: Match<Collection>, direction: MatchingDirection) -> AnyIterator<Match<Collection>> {
		switch direction {
			case .forward:	return AnyIterator(makeForwardMatchIterator(base: base))
			case .backward:	return AnyIterator(makeBackwardMatchIterator(base: base))
		}
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Collection, fromIndex inputPosition: Collection.Index) -> Collection.Index {
		return leadingPattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Collection, fromIndex inputPosition: Collection.Index) -> Collection.Index {
		return trailingPattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition)
	}
	
}
