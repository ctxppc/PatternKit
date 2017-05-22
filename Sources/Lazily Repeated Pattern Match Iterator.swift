// PatternKit © 2017 Constantino Tsarouhas

/// An iterator of matches of a lazily repeated pattern.
///
/// The match iterator exposes its internal cycling state as it iterates through the matches.
public struct LazilyRepeatedPatternMatchIterator<RepeatedPattern : Pattern> {
	
	internal init(repeatedPattern: RepeatedPattern, multiplicityRange: CountableClosedRange<Int>, base: Match<RepeatedPattern.Collection>) {
		self.repeatedPattern = repeatedPattern
		self.multiplicityRange = multiplicityRange
		self.cycles = [Cycle(match: base)]
	}
	
	
	/// The pattern that is repeated.
	public let repeatedPattern: RepeatedPattern
	
	/// The range of the number of times the pattern can be repeated.
	///
	/// - Invariant: `range.lowerBound >= 0`
	public let multiplicityRange: CountableClosedRange<Int>
	
	/// The cycles, indexed by multiplicity.
	///
	/// The zeroth cycle represents the base state where no iteration has occurred.
	public private(set) var cycles: [Cycle]
	
	/// A value representing the state of a particular iteration.
	public struct Cycle {
		
		/// Creates a cycle with given match iterator.
		///
		/// - Parameter matchIterator: A iterator over matches on this cycle.
		///
		/// - Returns: A cycle, or `nil` if the iterator has no matches.
		fileprivate init?(matchIterator: AnyIterator<Match<RepeatedPattern.Collection>>) {
			guard let firstMatch = matchIterator.next() else { return nil }
			activeMatch = firstMatch
			otherMatches = matchIterator
		}
		
		/// Creates a cycle with a single match.
		///
		/// - Parameter match: A match.
		fileprivate init(match: Match<RepeatedPattern.Collection>) {
			activeMatch = match
			otherMatches = none()
		}
		
		/// The match that is currently active.
		///
		/// All cycles following `self` are built upon this match.
		public fileprivate(set) var activeMatch: Match<RepeatedPattern.Collection>
		
		/// The other matches.
		fileprivate var otherMatches: AnyIterator<Match<RepeatedPattern.Collection>>
		
	}
	
	/// Cycles the iterator exactly once.
	///
	/// The iterator may need to cycle multiple times until the multiplicity is at or beyond the lower bound. The `next()` method does this.
	public mutating func cycle() {
		
		guard var lastCycle = cycles.last else { return }
		
		if let nextMatchInCycle = lastCycle.otherMatches.next() {
			lastCycle.activeMatch = nextMatchInCycle
			cycles[cycles.count] = lastCycle
		} else {
			cycles.removeLast()
			cycle()
		}
		
		// FIXME: Nowhere are new cycles created!
		
	}
	
	/// The iterator's candidate match, or `nil` if the iterator is exhausted.
	///
	/// Every cycle changes the candidate match. When the multiplicity is at or beyond the lower bound, the candidate match is an actual match of the iterator.
	public var candidateMatch: Match<RepeatedPattern.Collection>? {
		return cycles.last?.activeMatch
	}
	
	/// Whether the iterator is exhausted of matches.
	public var done: Bool {
		return cycles.isEmpty
	}
	
}

extension LazilyRepeatedPatternMatchIterator : IteratorProtocol {
	
	public mutating func next() -> Match<RepeatedPattern.Collection>? {
		
		while let candidateMatch = candidateMatch {
			if cycles.count >= multiplicityRange.lowerBound {
				return candidateMatch
			} else {
				cycle()
			}
		}
		
		return nil
		
	}
	
}
