// PatternKit © 2017 Constantino Tsarouhas

import DepthKit
import PatternKitCore

/// A pattern that performs matching of a subpattern repeatedly on consecutive subsequences of the target collection, preferring matching as few times as possible.
public struct LazilyRepeating<RepeatedPattern : Pattern> {
	
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
	
	/// The pattern that is repeated.
	public var repeatedPattern: RepeatedPattern
	
	/// The range of the number of times the pattern can be repeated.
	///
	/// - Invariant: `multiplicityRange.lowerBound >= 0`
	public var multiplicityRange: ClosedRange<Int> {
		willSet { precondition(newValue.lowerBound >= 0, "Negative lower bound") }
	}
	
}

extension LazilyRepeating {
	
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

public func repeating<RepeatedPattern>(_ repeatedPattern: RepeatedPattern, exactly multiplicity: Int) -> LazilyRepeating<RepeatedPattern> {
	return LazilyRepeating(repeatedPattern, exactly: multiplicity)
}

extension LazilyRepeating : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> LazyMapBidirectionalCollection<LazyFilterBidirectionalCollection<PreOrderFlatteningBidirectionalCollection<ForwardRing<RepeatedPattern>>>, Match<Subject>> {
		let minimumDepth = multiplicityRange.lowerBound
		let maximumDepth = multiplicityRange.upperBound == .max ? .max : multiplicityRange.upperBound + 1
		return ForwardRing(repeatedPattern: repeatedPattern, baseMatch: base)
			.flattenedInPreOrder(maximumDepth: maximumDepth)
			.lazy
			.filter { $0.depth >= minimumDepth }
			.map { $0.baseMatch }
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> LazyMapBidirectionalCollection<LazyFilterBidirectionalCollection<PreOrderFlatteningBidirectionalCollection<BackwardRing<RepeatedPattern>>>, Match<Subject>> {
		let minimumDepth = multiplicityRange.lowerBound
		let maximumDepth = multiplicityRange.upperBound == .max ? .max : multiplicityRange.upperBound + 1
		return BackwardRing(repeatedPattern: repeatedPattern, baseMatch: base)
			.flattenedInPreOrder(maximumDepth: maximumDepth)
			.lazy
			.filter { $0.depth >= minimumDepth }
			.map { $0.baseMatch }
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		guard multiplicityRange.lowerBound > 0 else { return inputPosition }
		return repeatedPattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		guard multiplicityRange.lowerBound > 0 else { return inputPosition }
		return repeatedPattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition)
	}
	
}

extension LazilyRepeating : BidirectionalCollection {
	
	public enum Index : Int, Hashable {
		
		/// The position of the repeated pattern.
		case repeatedPattern = 0
		
		/// The past-the-end position.
		case end
		
	}
	
	public var startIndex: Index {
		return .repeatedPattern
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> RepeatedPattern {
		precondition(index == .repeatedPattern, "Index out of bounds")
		return repeatedPattern
	}
	
	public func index(before index: Index) -> Index {
		precondition(index == .end, "Index out of bounds")
		return .repeatedPattern
	}
	
	public func index(after index: Index) -> Index {
		precondition(index == .repeatedPattern, "Index out of bounds")
		return .end
	}
	
}

extension LazilyRepeating.Index : Comparable {
	
	public static func <<P>(leftIndex: LazilyRepeating<P>.Index, rightIndex: LazilyRepeating<P>.Index) -> Bool {
		return leftIndex.rawValue < rightIndex.rawValue
	}
	
}

// TODO: Add literal & element initialisers (for autowrapping in Literal) when bugfix lands, in Swift 4 (or later)
