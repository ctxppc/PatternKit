// PatternKit © 2017 Constantino Tsarouhas

/// A collection of matches of a repeating pattern.
///
/// The repeating match collection matches the repeated pattern from the base match's input position backward, and then repeats this process recursively from the new matches' input position.
public struct BackwardRepeatingMatchCollection<RepeatedPattern : Pattern> {
	
	public typealias Subject = RepeatedPattern.Subject
	
	/// Creates a repeating match collection.
	///
	/// - Requires: `multiplicityRange.lowerBound >= 0`
	///
	/// - Parameter repeatedPattern: The pattern that is repeated.
	/// - Parameter lowerBound: The lower bound.
	/// - Parameter upperBound: The upper bound, inclusive.
	/// - Parameter tendency: The tendency of the repeating pattern to match its repeated pattern as few or as many times as possible within its multiplicity range.
	/// - Parameter baseMatch: The base match.
	internal init(repeatedPattern: RepeatedPattern, multiplicityRange: CountableClosedRange<Int>, tendency: Repeating<RepeatedPattern>.Tendency, baseMatch: Match<Subject>) {
		self.repeatedPattern = repeatedPattern
		self.multiplicityRange = multiplicityRange
		self.tendency = tendency
		self.baseMatch = baseMatch
	}
	
	/// The pattern that is repeated.
	public let repeatedPattern: RepeatedPattern
	
	/// The range of the number of times the pattern can be repeated.
	///
	/// - Invariant: `multiplicityRange.lowerBound >= 0`
	public let multiplicityRange: CountableClosedRange<Int>
	
	/// The tendency of the repeating pattern to match its repeated pattern as few or as many times as possible within its multiplicity range.
	public let tendency: Repeating<RepeatedPattern>.Tendency
	
	/// The base match.
	public let baseMatch: Match<Subject>
	
}

extension BackwardRepeatingMatchCollection : BidirectionalCollection {
	
	public enum Index {
		
		case some(indicesByMultiplicity: [RepeatedPattern.ForwardMatchCollection.Index])
		
		// TODO
		
	}
	
	public var startIndex: Index {
		unimplemented
	}
	
	public var endIndex: Index {
		unimplemented
	}
	
	public subscript (index: Index) -> Match<Subject> {
		unimplemented
	}
	
	public func index(before index: Index) -> Index {
		unimplemented
	}
	
	public func index(after index: Index) -> Index {
		unimplemented
	}
	
}

extension BackwardRepeatingMatchCollection.Index : Comparable {
	
	public static func <(leftIndex: BackwardRepeatingMatchCollection<RepeatedPattern>.Index, rightIndex: BackwardRepeatingMatchCollection<RepeatedPattern>.Index) -> Bool {
		unimplemented
	}
	
	public static func ==(leftIndex: BackwardRepeatingMatchCollection<RepeatedPattern>.Index, rightIndex: BackwardRepeatingMatchCollection<RepeatedPattern>.Index) -> Bool {
		unimplemented
	}
	
}
