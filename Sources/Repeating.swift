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
	
	public func matches(proceedingFrom origin: Match<RepeatedPattern.Collection>) -> AnyIterator<Match<RepeatedPattern.Collection>> {
		
		var tree = MultiplicationTree(origin: origin, repeatedPattern: repeatedPattern)
		
		func lazyMatches() -> AnyIterator<Match<RepeatedPattern.Collection>> {
			
			var currentMultiplicity = multiplicityRange.lowerBound
			var iteratorForCurrentMultiplicity = tree[multiplicity: currentMultiplicity].makeIterator()
			
			return AnyIterator {
				if let matchForCurrentMultiplicity = iteratorForCurrentMultiplicity.next() {
					return matchForCurrentMultiplicity
				} else {
					
					currentMultiplicity += 1
					guard currentMultiplicity <= self.multiplicityRange.upperBound else { return nil }
					
					iteratorForCurrentMultiplicity = tree[multiplicity: currentMultiplicity].makeIterator()
					
					guard let firstMatchForCurrentMultiplicity = iteratorForCurrentMultiplicity.next() else { return nil }
					return firstMatchForCurrentMultiplicity
					
				}
			}
			
		}
		
		func eagerMatches() -> AnyIterator<Match<RepeatedPattern.Collection>> {
			
			tree.precompute(upToMultiplicity: multiplicityRange.upperBound)
			let maximumMultiplicity = tree.computedMaximalMultiplicity ?? multiplicityRange.upperBound
			
			guard maximumMultiplicity >= multiplicityRange.lowerBound else { return none() }
			
			var currentMultiplicity = maximumMultiplicity
			var iteratorForCurrentMultiplicity = tree[multiplicity: currentMultiplicity].makeIterator()
			
			return AnyIterator {
				if let matchForCurrentMultiplicity = iteratorForCurrentMultiplicity.next() {
					return matchForCurrentMultiplicity
				} else {
					
					currentMultiplicity -= 1
					guard currentMultiplicity >= self.multiplicityRange.lowerBound else { return nil }
					
					iteratorForCurrentMultiplicity = tree[multiplicity: currentMultiplicity].makeIterator()
					
					return iteratorForCurrentMultiplicity.next()!
					
				}
			}
			
		}
		
		func possessiveMatches() -> AnyIterator<Match<RepeatedPattern.Collection>> {
			
			tree.precompute(upToMultiplicity: multiplicityRange.upperBound)
			let maximumMultiplicity = tree.computedMaximalMultiplicity ?? multiplicityRange.upperBound
			
			guard maximumMultiplicity >= multiplicityRange.lowerBound else { return none() }
			
			return AnyIterator(tree[multiplicity: maximumMultiplicity].makeIterator())
			
		}
		
		switch tendency {
			case .lazy:			return lazyMatches()
			case .eager:		return eagerMatches()
			case .possessive:	return possessiveMatches()
		}
		
	}
	
}

postfix operator *
postfix operator +
postfix operator *?
postfix operator +?
postfix operator /?

public postfix func *<P : Pattern>(o: P) -> Repeating<P> {
	return Repeating(o)
}

public postfix func +<P : Pattern>(o: P) -> Repeating<P> {
	return Repeating(o, min: 1)
}

public postfix func *?<P : Pattern>(o: P) -> Repeating<P> {
	return Repeating(o, tendency: .lazy)
}

public postfix func +?<P : Pattern>(o: P) -> Repeating<P> {
	return Repeating(o, min: 1, tendency: .lazy)
}

public postfix func /?<P : Pattern>(o: P) -> Repeating<P> {
	return Repeating(o, max: 1)
}

private struct MultiplicationTree<Collection : BidirectionalCollection, RepeatedPattern : Pattern> where RepeatedPattern.Collection == Collection {
	
	/// Creates a match multiplication tree.
	///
	/// - Parameter origin: The repeating pattern's origin.
	/// - Parameter repeatedPattern: The repeated pattern.
	init(origin: Match<Collection>, repeatedPattern: RepeatedPattern) {
		matchesByMultiplicity = [[origin]]
		computedMaximalMultiplicity = nil
		self.repeatedPattern = repeatedPattern
	}
	
	/// The matches generated by the repeated pattern, by multiplicity.
	///
	/// - Invariant: The zeroth multiplicity contains exactly one match, namely the repeating pattern's origin match.
	/// - Invariant: No array *in* `matchesByMultiplicity` is empty.
	private var matchesByMultiplicity: [[Match<Collection>]]
	
	/// The maximal multiplicity that is possible, or `nil` if it hasn't been computed yet.
	///
	/// - Invariant: If set, `computedMaximalMultiplicity` ≥ 0.
	private(set) var computedMaximalMultiplicity: Int?
	
	/// The repeated pattern.
	private let repeatedPattern: RepeatedPattern
	
	/// Accesses the sequence of matches at a given multiplicity.
	///
	/// - Requires: `multiplicity >= 0`
	///
	/// - Parameter multiplicity: The multiplicity.
	subscript (multiplicity multiplicity: Int) -> [Match<Collection>] {
		mutating get {
			
			let repeatedPattern = self.repeatedPattern
			
			if let maximalMultiplicity = computedMaximalMultiplicity, multiplicity > maximalMultiplicity {
				return []
			}
			
			if !matchesByMultiplicity.indices.contains(multiplicity) {
				assert(computedMaximalMultiplicity == nil, "Maximal multiplicity already computed yet we compute more multiplicities!")
				var matchesOfPreviousMultiplicity = matchesByMultiplicity.last!
				for currentMultiplicity in matchesByMultiplicity.endIndex...multiplicity {
					
					let matchesOfCurrentMultiplicity = matchesOfPreviousMultiplicity.flatMap { (originMatchForCurrentMultiplicity: Match<Collection>) -> AnyIterator<Match<Collection>> in
						return repeatedPattern.matches(proceedingFrom: originMatchForCurrentMultiplicity)
					}
					
					guard !matchesOfCurrentMultiplicity.isEmpty else {	// Max multiplicity reached!
						computedMaximalMultiplicity = currentMultiplicity - 1
						return []
					}
					
					matchesOfPreviousMultiplicity = matchesOfCurrentMultiplicity
					
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
