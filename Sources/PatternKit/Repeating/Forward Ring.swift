// PatternKit © 2017–21 Constantino Tsarouhas

/// An iteration of a repeatedly forward-matching pattern.
///
/// A ring takes a base match and produces a successor ring for every match produced by the repeated pattern given the base match. The successor rings themselves can be used to generate further descendant rings. Given a *root* ring, one can determine a tree of ring and thus of matches.
public struct ForwardRing<RepeatedPattern : Pattern> {
	
	public typealias Subject = RepeatedPattern.Subject
	public typealias MatchCollection = RepeatedPattern.ForwardMatchCollection
	
	/// Creates a ring.
	///
	/// - Requires: `depth >= 0`
	///
	/// - Parameter repeatedPattern: The pattern that is being repeatedly matched.
	/// - Parameter baseMatch: The match from which successor matches are generated.
	/// - Parameter depth: The number of rings that precede this ring. The ring built from the origin match has depth 0. The default is zero.
	public init(repeatedPattern: RepeatedPattern, baseMatch: Match<Subject>, depth: Int = 0) {
		self.repeatedPattern = repeatedPattern
		self.baseMatch = baseMatch
		self.successorMatches = repeatedPattern.forwardMatches(enteringFrom: baseMatch)
		self.depth = depth
	}
	
	/// The pattern that is being repeatedly matched.
	public let repeatedPattern: RepeatedPattern
	
	/// The match from which successor matches are generated.
	public let baseMatch: Match<Subject>
	
	/// The matches that are the result of applying the repeated pattern using the base match.
	public let successorMatches: MatchCollection
	
	/// The rings that represent the next iteration, one for every successor match.
	public var successorRings: LazyMapCollection<MatchCollection, ForwardRing> {
		let repeatedPattern = self.repeatedPattern
		let newDepth = depth + 1
		return successorMatches.lazy.map { successorMatch in
			.init(repeatedPattern: repeatedPattern, baseMatch: successorMatch, depth: newDepth)
		}
	}
	
	/// The number of rings that precede this ring.
	///
	/// The ring built from the origin match has depth 0.
	///
	/// - Invariant: `depth >= 0`
	public let depth: Int
	
}

extension ForwardRing : BidirectionalCollection {
	public typealias Index = MatchCollection.Index
	public var startIndex: Index { successorMatches.startIndex }
	public var endIndex: Index { successorMatches.endIndex }
	public subscript (index: Index) -> ForwardRing { successorRings[index] }
	public func index(before index: Index) -> Index { successorMatches.index(before: index) }
	public func index(after index: Index) -> Index { successorMatches.index(after: index) }
}
