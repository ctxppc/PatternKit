// PatternKit © 2017 Constantino Tsarouhas

import DepthKit

/// A pattern that performs matching of a subpattern repeatedly on consecutive subsequences of the target collection, preferring matching as many times as possible.
public struct EagerlyRepeating<RepeatedPattern : Pattern> where
	RepeatedPattern.ForwardMatchCollection.Iterator.Element == Match<RepeatedPattern.Subject>,
	RepeatedPattern.BackwardMatchCollection.Iterator.Element == Match<RepeatedPattern.Subject> {
	
	public typealias Subject = RepeatedPattern.Subject
	
	/// Creates a repeating pattern.
	///
	/// - Requires: `lowerBound >= 0` and `lowerBound <= upperBound`
	///
	/// - Parameter repeatedPattern: The pattern that is repeated.
	/// - Parameter lowerBound: The minimal number of times the repeated pattern must be matched. The default is zero.
	/// - Parameter upperBound: The maximal number of times the repeated pattern may be matched. The default is `Int.max`.
	public init(_ repeatedPattern: RepeatedPattern, min lowerBound: Int = 0, max upperBound: Int = .max) {
		precondition(lowerBound >= 0, "Negative lower bound")
		self.repeatedPattern = repeatedPattern
		multiplicityRange = lowerBound...upperBound
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
	
}

extension EagerlyRepeating : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> LazyMapBidirectionalCollection<LazyFilterBidirectionalCollection<PreOrderFlatteningBidirectionalCollection<ForwardRing<RepeatedPattern>>>, Match<RepeatedPattern.Subject>> {
		unimplemented	// TODO
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> LazyMapBidirectionalCollection<LazyFilterBidirectionalCollection<PreOrderFlatteningBidirectionalCollection<BackwardRing<RepeatedPattern>>>, Match<RepeatedPattern.Subject>> {
		unimplemented	// TODO
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: RepeatedPattern.Subject, fromIndex inputPosition: RepeatedPattern.Subject.Index) -> RepeatedPattern.Subject.Index {
		unimplemented	// TODO
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: RepeatedPattern.Subject, fromIndex inputPosition: RepeatedPattern.Subject.Index) -> RepeatedPattern.Subject.Index {
		unimplemented	// TODO
	}
	
}

extension EagerlyRepeating {
	
	/// Creates a repeating pattern.
	///
	/// - Requires: `multiplicity >= 0`
	///
	/// - Parameter repeatedPattern: The pattern that is repeated.
	/// - Parameter multiplicity: The number of times to match the repeated pattern consecutively.
	public init(_ repeatedPattern: RepeatedPattern, exactly multiplicity: Int) {
		self.init(repeatedPattern, min: multiplicity, max: multiplicity)
	}
	
}

// TODO: Add literal & element initialisers (for autowrapping in Literal) when bugfix lands, in Swift 4 (or later)
