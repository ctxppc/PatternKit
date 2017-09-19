// PatternKit © 2017 Constantino Tsarouhas

import PatternKitCore

public struct NegatedForwardAssertionMatchCollection<AssertedPattern : Pattern> {
	
	public typealias Subject = AssertedPattern.Subject
	
	/// Creates a negated forward assertion match collection.
	///
	/// - Parameter assertedPattern: The pattern that must produce no match for the assertion to hold.
	/// - Parameter baseMatch: The base match.
	internal init(assertedPattern: AssertedPattern, baseMatch: Match<Subject>) {
		self.assertedPattern = assertedPattern
		self.matchesOfAssertedPattern = assertedPattern.forwardMatches(enteringFrom: baseMatch)
		self.baseMatch = baseMatch
	}
	
	/// The pattern that must produce no match for the assertion to hold.
	public let assertedPattern: AssertedPattern
	
	/// The matches of the asserted pattern.
	///
	/// If empty, the negated assertion match collection contains the base match. Otherwise, it is empty.
	public let matchesOfAssertedPattern: AssertedPattern.ForwardMatchCollection
	
	/// The base match.
	public let baseMatch: Match<Subject>
	
}

extension NegatedForwardAssertionMatchCollection : BidirectionalCollection {
	
	public enum Index {
		
		/// The position of the base match if the negated assertion holds, otherwise the end index of the collection.
		case baseMatch
		
		/// The position after the base match of the collection if the negated assertion holds, otherwise an invalid index.
		case afterBaseMatch
		
	}
	
	public var startIndex: Index {
		return .baseMatch
	}
	
	public var endIndex: Index {
		if matchesOfAssertedPattern.isEmpty {
			return .afterBaseMatch
		} else {
			return .baseMatch
		}
	}
	
	public subscript (index: Index) -> Match<Subject> {
		guard matchesOfAssertedPattern.isEmpty else { preconditionFailure("Index out of bounds: negated assertion does not hold") }
		return baseMatch
	}
	
	public func index(before index: Index) -> Index {
		switch index {
			case .baseMatch:		preconditionFailure("Index out of bounds")
			case .afterBaseMatch:	return .baseMatch
		}
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			case .baseMatch:		return .afterBaseMatch
			case .afterBaseMatch:	preconditionFailure("Index out of bounds")
		}
	}
	
}

extension NegatedForwardAssertionMatchCollection.Index : Comparable {
	
	public static func <(leftIndex: NegatedForwardAssertionMatchCollection<AssertedPattern>.Index, rightIndex: NegatedForwardAssertionMatchCollection<AssertedPattern>.Index) -> Bool {
		return (leftIndex, rightIndex) == (.baseMatch, .afterBaseMatch)
	}
	
}
