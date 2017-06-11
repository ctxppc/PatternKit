// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that performs matching of a subpattern repeatedly on consecutive subsequences of the target collection.
public struct Repeating<RepeatedPattern : Pattern> {
	
	public typealias Subject = RepeatedPattern.Subject
	
	/// Creates a repeating pattern.
	///
	/// - Requires: `lowerBound >= 0` and `lowerBound <= upperBound`
	///
	/// - Parameter repeatedPattern: The pattern that is repeated.
	/// - Parameter lowerBound: The minimal number of times the repeated pattern must be matched. The default is zero.
	/// - Parameter upperBound: The maximal number of times the repeated pattern may be matched. The default is `Int.max`.
	/// - Parameter tendency: The tendency of the repeating pattern to match its repeated pattern as few or as many times as possible within its multiplicity range. The default is eager matching.
	public init(_ repeatedPattern: RepeatedPattern, min lowerBound: Int = 0, max upperBound: Int = .max, tendency: Tendency = .eager) {
		precondition(lowerBound >= 0, "Negative lower bound")
		self.repeatedPattern = repeatedPattern
		multiplicityRange = lowerBound...upperBound
		self.tendency = tendency
	}
	
	// TODO: Replace min & max arguments in initialiser by a suitable `RangeExpression` argument, in Swift 4
	
	/// The pattern that is repeated.
	public var repeatedPattern: RepeatedPattern
	
	/// The range of the number of times the pattern can be repeated.
	///
	/// - Invariant: `multiplicityRange.lowerBound >= 0`
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
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> ForwardRepeatingMatchCollection<RepeatedPattern> {
		return ForwardRepeatingMatchCollection(repeatedPattern: repeatedPattern, multiplicityRange: multiplicityRange, tendency: tendency, baseMatch: base)
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> BackwardRepeatingMatchCollection<RepeatedPattern> {
		return BackwardRepeatingMatchCollection(repeatedPattern: repeatedPattern, multiplicityRange: multiplicityRange, tendency: tendency, baseMatch: base)
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: RepeatedPattern.Subject, fromIndex inputPosition: RepeatedPattern.Subject.Index) -> RepeatedPattern.Subject.Index {
		unimplemented	// TODO
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: RepeatedPattern.Subject, fromIndex inputPosition: RepeatedPattern.Subject.Index) -> RepeatedPattern.Subject.Index {
		unimplemented	// TODO
	}
	
}

extension Repeating {
	
	/// Creates a repeating pattern.
	///
	/// - Requires: `multiplicity >= 0`
	///
	/// - Parameter repeatedPattern: The pattern that is repeated.
	/// - Parameter multiplicity: The number of times to match the repeated pattern consecutively.
	public init(_ repeatedPattern: RepeatedPattern, exactly multiplicity: Int) {
		self.init(repeatedPattern, min: multiplicity, max: multiplicity, tendency: .eager)
	}
	
}

// TODO: Add literal & element initialisers (for autowrapping in Literal) when bugfix lands, in Swift 4 (or later)
