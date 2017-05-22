// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that performs matching of a subpattern repeatedly on consecutive subsequences of the target collection.
public struct Repeating<RepeatedPattern : Pattern> {
	
	/// Creates a repeating pattern.
	///
	/// - Requires: `lowerBound >= 0`
	///
	/// - Parameter repeatedPattern: The pattern that is repeated.
	/// - Parameter lowerBound: The lower bound. The default is zero.
	/// - Parameter upperBound: The upper bound, inclusive. The default is `Int.max`.
	/// - Parameter tendency: The tendency of the repeating pattern to match its repeated pattern as few or as many times as possible within its multiplicity range. The default is eager matching.
	public init(_ repeatedPattern: RepeatedPattern, min lowerBound: Int = 0, max upperBound: Int = .max, tendency: Tendency = .eager) {
		precondition(lowerBound >= 0, "Negative lower bound")
		self.repeatedPattern = repeatedPattern
		multiplicityRange = lowerBound...upperBound
		self.tendency = tendency
	}
	
	/// The pattern that is repeated.
	public var repeatedPattern: RepeatedPattern
	
	/// The range of the number of times the pattern can be repeated.
	///
	/// - Invariant: `range.lowerBound >= 0`
	public var multiplicityRange: CountableClosedRange<Int> {
		willSet { precondition(newValue.lowerBound >= 0, "Negative lower bound") }
	}
	
	/// The tendency of the repeating pattern to match its repeated pattern as few or as many times as possible within its multiplicity range.
	public var tendency: Tendency
	public enum Tendency {
		
		/// The repeating pattern tends to match the repeated pattern as **few** times as possible within range.
		case lazy
		
		/// The repeating pattern tends to match the repeated pattern as **many** times as possible within range.
		case eager
		
		/// The repeating pattern tends to match the repeated pattern as **many** times as possible within range, and **no fewer**.
		///
		/// Possessive matching is similar to eager matching, with the exception that possessive matching disables backtracking over itself. This can be used as an optimisation.
		case possessive
		
	}
	
}

extension Repeating : Pattern {
	
	public func matches(base: Match<RepeatedPattern.Collection>, direction: MatchingDirection) -> AnyIterator<Match<RepeatedPattern.Collection>> {
		
		var cycleMatcher = CycleMatcher(repeatedPattern: repeatedPattern, base: base, direction: direction)
		
		func lazyMatches() -> AnyIterator<Match<RepeatedPattern.Collection>> {
			
			var currentMultiplicity = multiplicityRange.lowerBound
			var iteratorForCurrentMultiplicity = cycleMatcher[multiplicity: currentMultiplicity].makeIterator()
			
			return AnyIterator {
				if let matchForCurrentMultiplicity = iteratorForCurrentMultiplicity.next() {
					return matchForCurrentMultiplicity
				} else {
					
					currentMultiplicity += 1
					guard currentMultiplicity <= self.multiplicityRange.upperBound else { return nil }
					
					iteratorForCurrentMultiplicity = cycleMatcher[multiplicity: currentMultiplicity].makeIterator()
					
					guard let firstMatchForCurrentMultiplicity = iteratorForCurrentMultiplicity.next() else { return nil }
					return firstMatchForCurrentMultiplicity
					
				}
			}
			
		}
		
		func eagerMatches() -> AnyIterator<Match<RepeatedPattern.Collection>> {
			
			cycleMatcher.precompute(upToMultiplicity: multiplicityRange.upperBound)
			let maximumMultiplicity = cycleMatcher.reachedMaximalMultiplicity ?? multiplicityRange.upperBound
			
			guard maximumMultiplicity >= multiplicityRange.lowerBound else { return none() }
			
			var currentMultiplicity = maximumMultiplicity
			var iteratorForCurrentMultiplicity = cycleMatcher[multiplicity: currentMultiplicity].makeIterator()
			
			return AnyIterator {
				if let matchForCurrentMultiplicity = iteratorForCurrentMultiplicity.next() {
					return matchForCurrentMultiplicity
				} else {
					
					currentMultiplicity -= 1
					guard currentMultiplicity >= self.multiplicityRange.lowerBound else { return nil }
					
					iteratorForCurrentMultiplicity = cycleMatcher[multiplicity: currentMultiplicity].makeIterator()
					
					return iteratorForCurrentMultiplicity.next()!
					
				}
			}
			
		}
		
		func possessiveMatches() -> AnyIterator<Match<RepeatedPattern.Collection>> {
			
			cycleMatcher.precompute(upToMultiplicity: multiplicityRange.upperBound)
			let maximumMultiplicity = cycleMatcher.reachedMaximalMultiplicity ?? multiplicityRange.upperBound
			
			guard maximumMultiplicity >= multiplicityRange.lowerBound else { return none() }
			
			return AnyIterator(cycleMatcher[multiplicity: maximumMultiplicity].makeIterator())
			
		}
		
		switch tendency {
			case .lazy:			return lazyMatches()
			case .eager:		return eagerMatches()
			case .possessive:	return possessiveMatches()
		}
		
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: RepeatedPattern.Collection, fromIndex inputPosition: RepeatedPattern.Collection.Index) -> RepeatedPattern.Collection.Index {
		return repeatedPattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: RepeatedPattern.Collection, fromIndex inputPosition: RepeatedPattern.Collection.Index) -> RepeatedPattern.Collection.Index {
		return repeatedPattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition)
	}
	
}

/// A structure that performs repeated matches and provides on-demand matches for any given multiplicity.
private struct CycleMatcher<RepeatedPattern : Pattern> where RepeatedPattern.Collection : BidirectionalCollection {
	
	/// Creates a cycle matcher.
	///
	/// - Parameter repeatedPattern: The pattern that performs matches in each cycle.
	/// - Parameter base: The base match from where the first cycle is performed.
	/// - Parameter direction: The direction in which matching is performed.
	init(repeatedPattern: RepeatedPattern, base: Match<RepeatedPattern.Collection>, direction: MatchingDirection) {
		self.repeatedPattern = repeatedPattern
		self.direction = direction
		self.matchesByMultiplicity = [[base]]
	}
	
	/// The pattern that performs matches in each cycle.
	let repeatedPattern: RepeatedPattern
	
	/// The direction in which matching is performed.
	let direction: MatchingDirection
	
	/// The matches generated by the repeated pattern, by multiplicity.
	///
	/// - Invariant: The zeroth multiplicity contains exactly one match, namely the base match.
	/// - Invariant: No array *in* `matchesByMultiplicity` is empty.
	private var matchesByMultiplicity: [[Match<RepeatedPattern.Collection>]]
	
	/// The maximal multiplicity that is available, if that upper bound has been reached by the cycle matcher.
	///
	/// - Invariant: If `reachedMaximalMultiplicity` is not `nil`, `matchesByMultiplicity.count == reachedMaximalMultiplicity - 1`.
	private(set) var reachedMaximalMultiplicity: Int?
	
	/// Accesses the sequence of matches at a given multiplicity.
	///
	/// - Requires: `multiplicity >= 0`
	///
	/// - Parameter multiplicity: The multiplicity.
	subscript (multiplicity multiplicity: Int) -> [Match<RepeatedPattern.Collection>] {
		mutating get {
			
			assert(multiplicity >= 0, "Negative multiplicity")
			
			if let reachedMaximalMultiplicity = reachedMaximalMultiplicity {
				guard multiplicity < reachedMaximalMultiplicity else { return [] }
			}
			
			if !matchesByMultiplicity.indices.contains(multiplicity) {
				
				assert(reachedMaximalMultiplicity == nil, "Maximal multiplicity reached while entering in cycling mode")
				
				var matchesOfLastCycle = matchesByMultiplicity.last!
				
				for multiplicityOfCurrentCycle in matchesByMultiplicity.endIndex...multiplicity {
					
					let matchesOfCurrentCycle = matchesOfLastCycle.flatMap { baseMatchForCurrentCycle in
						repeatedPattern.matches(base: baseMatchForCurrentCycle, direction: direction)
					}
					
					if matchesOfCurrentCycle.isEmpty {
						reachedMaximalMultiplicity = multiplicityOfCurrentCycle - 1
						return []
					} else {
						matchesByMultiplicity.append(matchesOfCurrentCycle)
						matchesOfLastCycle = matchesOfCurrentCycle
					}
					
				}
				
			}
			
			return matchesByMultiplicity[multiplicity]
			
		}
	}
	
	/// Eagerly precomputes up to a given multiplicity.
	///
	/// - Requires: `multiplicity >= 0`
	///
	/// - Parameter multiplicity: The multiplicity.
	mutating func precompute(upToMultiplicity multiplicity: Int) {
		_ = self[multiplicity: multiplicity]
	}
	
}
