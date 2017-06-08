// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that never produces matches.
///
/// Use a bin pattern on paths that are to be discarded early, e.g., for performance reasons.
public struct Bin<Subject : BidirectionalCollection> {}

extension Bin : Pattern {
	
	public func matches(base: Match<Subject>, direction: MatchingDirection) -> EmptyCollection<Subject> {
		return EmptyCollection()
	}
	
}

extension Bin : ExpressibleByNilLiteral {
	
	public init(nilLiteral: ()) {
		self.init()
	}
	
}
