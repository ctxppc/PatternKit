// PatternKit © 2017 Constantino Tsarouhas

public final class Token<Subpattern : Pattern> where
	Subpattern.ForwardMatchCollection.Iterator.Element == Match<Subpattern.Subject>,
	Subpattern.BackwardMatchCollection.Iterator.Element == Match<Subpattern.Subject> {
	
	/// Creates a token capturing matches from a subpattern.
	///
	/// - Parameter subpattern: The subpattern.
	public init(_ subpattern: Subpattern) {
		self.subpattern = subpattern
	}
	
	/// The subpattern.
	public let subpattern: Subpattern
	
}

extension Token : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subpattern.Subject>) -> LazyMapBidirectionalCollection<Subpattern.ForwardMatchCollection, Match<Subpattern.Subject>> {
		return subpattern
			.forwardMatches(enteringFrom: base)
			.lazy
			.map { $0.capturing(base.inputPosition..<$0.inputPosition, for: self) }
	}
	
	public func backwardMatches(recedingFrom base: Match<Subpattern.Subject>) -> LazyMapBidirectionalCollection<Subpattern.BackwardMatchCollection, Match<Subpattern.Subject>> {
		return subpattern
			.backwardMatches(recedingFrom: base)
			.lazy
			.map { $0.capturing($0.inputPosition..<base.inputPosition, for: self) }
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subpattern.Subject, fromIndex inputPosition: Subpattern.Subject.Index) -> Subpattern.Subject.Index {
		return subpattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subpattern.Subject, fromIndex inputPosition: Subpattern.Subject.Index) -> Subpattern.Subject.Index {
		return subpattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition)
	}
	
}
