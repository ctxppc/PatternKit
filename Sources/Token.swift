// PatternKit © 2017 Constantino Tsarouhas

public final class Token<Subpattern : Pattern> where Subpattern.MatchCollection.Iterator.Element == Match<Subpattern.Subject> {
	
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
	
	public func matches(base: Match<Subpattern.Subject>, direction: MatchingDirection) -> LazyMapBidirectionalCollection<Subpattern.MatchCollection, Match<Subpattern.Subject>> {
		return subpattern.matches(base: base, direction: direction).lazy.map { innerMatch in
			switch direction {
				case .forward:	return innerMatch.capturing(base.inputPosition..<innerMatch.inputPosition, for: self)
				case .backward:	return innerMatch.capturing(innerMatch.inputPosition..<base.inputPosition, for: self)
			}
		}
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subpattern.Subject, fromIndex inputPosition: Subpattern.Subject.Index) -> Subpattern.Subject.Index {
		return subpattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subpattern.Subject, fromIndex inputPosition: Subpattern.Subject.Index) -> Subpattern.Subject.Index {
		return subpattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition)
	}
	
}
