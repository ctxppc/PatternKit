// PatternKit © 2017 Constantino Tsarouhas

/// A collection of matches of a repeating pattern.
///
/// The repeating match collection matches the repeated pattern from the base match's input position forward, and then repeats this process recursively from the new matches' input position.
public struct ForwardRepeatingMatchCollection<RepeatedPattern : Pattern> {
	
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

extension ForwardRepeatingMatchCollection : BidirectionalCollection {
	
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

extension ForwardRepeatingMatchCollection.Index : Comparable {
	
	public static func <(leftIndex: ForwardRepeatingMatchCollection<RepeatedPattern>.Index, rightIndex: ForwardRepeatingMatchCollection<RepeatedPattern>.Index) -> Bool {
		unimplemented
	}
	
	public static func ==(leftIndex: ForwardRepeatingMatchCollection<RepeatedPattern>.Index, rightIndex: ForwardRepeatingMatchCollection<RepeatedPattern>.Index) -> Bool {
		unimplemented
	}
	
}
