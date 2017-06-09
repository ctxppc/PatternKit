// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that performs matching of a subpattern repeatedly on consecutive subsequences of the target collection.
public struct Repeating<RepeatedPattern : Pattern> {
	
	/// Creates a repeating pattern.
	///
	/// - Requires: `multiplicityRange.lowerBound >= 0`
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
	
	public func matches(base: Match<RepeatedPattern.Subject>, direction: MatchingDirection) -> RepeatingMatchCollection<RepeatedPattern> {
		return RepeatingMatchCollection(repeatedPattern: repeatedPattern, multiplicityRange: multiplicityRange, tendency: tendency)
	}
	
}
