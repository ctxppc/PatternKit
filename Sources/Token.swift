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
	
	public func matches(proceedingFrom origin: Match<Subpattern.Collection>) -> AnyIterator<Match<Subpattern.Collection>> {
		let innerIterator = subpattern.matches(proceedingFrom: origin)
		return AnyIterator {
			guard let innerMatch = innerIterator.next() else { return nil }
			return innerMatch.capturing(origin.inputPosition..<innerMatch.inputPosition, for: self)
		}
	}
	
}
