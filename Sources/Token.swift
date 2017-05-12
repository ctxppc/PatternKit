// PatternKit © 2017 Constantino Tsarouhas

public final class Token<Subpattern : Pattern> {
	
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
	
	public func matches(base: Match<Subpattern.Collection>, direction: MatchingDirection) -> AnyIterator<Match<Subpattern.Collection>> {
		let innerIterator = subpattern.matches(base: base, direction: direction)
		return AnyIterator {
			guard let innerMatch = innerIterator.next() else { return nil }
			switch direction {
				case .forward:	return innerMatch.capturing(base.inputPosition..<innerMatch.inputPosition, for: self)
				case .backward:	return innerMatch.capturing(innerMatch.inputPosition..<base.inputPosition, for: self)
			}
		}
	}
	
}
