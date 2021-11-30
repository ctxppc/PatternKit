// PatternKit © 2017–21 Constantino Tsarouhas

/// A pattern that never produces matches.
///
/// Use a bin pattern on paths that are to be discarded early, e.g., for performance reasons.
public struct Bin<Subject : BidirectionalCollection> where Subject.Element : Equatable {}

extension Bin : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> EmptyCollection<Match<Subject>> {
		.init()
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> EmptyCollection<Match<Subject>> {
		.init()
	}
	
}

extension Bin : ExpressibleByNilLiteral {
	public init(nilLiteral: ()) {
		self.init()
	}
}
