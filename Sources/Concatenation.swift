// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches two patterns sequentially.
public struct Concatenation<LeadingPattern : Pattern, TrailingPattern : Pattern> where
	
	LeadingPattern.Subject == TrailingPattern.Subject,
	
	LeadingPattern.ForwardMatchCollection.Iterator.Element == Match<LeadingPattern.Subject>,
	LeadingPattern.ForwardMatchCollection.Indices : OrderedCollection,
	LeadingPattern.ForwardMatchCollection.Indices.Iterator.Element == LeadingPattern.ForwardMatchCollection.Index,
	LeadingPattern.ForwardMatchCollection.Indices.SubSequence.Iterator.Element == LeadingPattern.ForwardMatchCollection.Index,
	TrailingPattern.ForwardMatchCollection.Iterator.Element == Match<TrailingPattern.Subject>,
	TrailingPattern.ForwardMatchCollection.Indices : OrderedCollection,
	TrailingPattern.ForwardMatchCollection.Indices.Iterator.Element == TrailingPattern.ForwardMatchCollection.Index,
	TrailingPattern.ForwardMatchCollection.Indices.SubSequence.Iterator.Element == TrailingPattern.ForwardMatchCollection.Index,

	LeadingPattern.BackwardMatchCollection.Iterator.Element == Match<LeadingPattern.Subject>,
	LeadingPattern.BackwardMatchCollection.Indices : OrderedCollection,
	LeadingPattern.BackwardMatchCollection.Indices.Iterator.Element == LeadingPattern.BackwardMatchCollection.Index,
	LeadingPattern.BackwardMatchCollection.Indices.SubSequence.Iterator.Element == LeadingPattern.BackwardMatchCollection.Index,
	TrailingPattern.BackwardMatchCollection.Iterator.Element == Match<TrailingPattern.Subject>,
	TrailingPattern.BackwardMatchCollection.Indices : OrderedCollection,
	TrailingPattern.BackwardMatchCollection.Indices.Iterator.Element == TrailingPattern.BackwardMatchCollection.Index,
	TrailingPattern.BackwardMatchCollection.Indices.SubSequence.Iterator.Element == TrailingPattern.BackwardMatchCollection.Index {
	
	// TODO: Update constraints after updating constraints in match collection type, in Swift 4
	
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
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> ForwardConcatenationMatchCollection<LeadingPattern, TrailingPattern> {
		return ForwardConcatenationMatchCollection(leadingPattern: leadingPattern, trailingPattern: trailingPattern, baseMatch: base)
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> BackwardConcatenationMatchCollection<LeadingPattern, TrailingPattern> {
		return BackwardConcatenationMatchCollection(leadingPattern: leadingPattern, trailingPattern: trailingPattern, baseMatch: base)
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return leadingPattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return trailingPattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition)
	}
	
}
