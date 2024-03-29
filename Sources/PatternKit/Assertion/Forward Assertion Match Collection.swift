// PatternKit © 2017–21 Constantino Tsarouhas

public struct ForwardAssertionMatchCollection<AssertedPattern : Pattern> {
	
	public typealias Subject = AssertedPattern.Subject
	
	/// Creates a forward assertion match collection.
	///
	/// - Parameter assertedPattern: The pattern that must produce at least one match for the assertion to hold.
	/// - Parameter baseMatch: The base match.
	internal init(assertedPattern: AssertedPattern, baseMatch: Match<Subject>) {
		self.assertedPattern = assertedPattern
		self.baseMatch = baseMatch
	}
	
	/// The pattern that must produce at least one match for the assertion to hold.
	public let assertedPattern: AssertedPattern
	
	/// The base match.
	public let baseMatch: Match<Subject>
	
}

extension ForwardAssertionMatchCollection : BidirectionalCollection {
	
	public enum Index : Equatable {
		
		/// A position within the asserted pattern.
		///
		/// - Invariant: `innerIndex` is not equal to `endIndex` of the asserted pattern's match collection.
		///
		/// - Parameter innerIndex: The index on the asserted pattern's match collection referring to the match that caused the assertion to hold.
		case some(innerIndex: AssertedPattern.ForwardMatchCollection.Index)
		
		/// The position after the last element of the collection.
		case end
		
	}
	
	public var startIndex: Index {
		let matchesOfAssertedPattern = assertedPattern.forwardMatches(enteringFrom: baseMatch)
		let indexOfFirstMatchOfAssertedPattern = matchesOfAssertedPattern.startIndex
		guard indexOfFirstMatchOfAssertedPattern != matchesOfAssertedPattern.endIndex else { return .end }
		return .some(innerIndex: indexOfFirstMatchOfAssertedPattern)
	}
	
	public var endIndex: Index { .end }
	
	public subscript (index: Index) -> Match<Subject> {
		let matchesOfAssertedPattern = assertedPattern.forwardMatches(enteringFrom: baseMatch)
		guard case .some(innerIndex: let innerIndex) = index else { preconditionFailure("Index out of bounds") }
		return matchesOfAssertedPattern[innerIndex].resuming(from: baseMatch)
	}
	
	public func index(before index: Index) -> Index {
		
		precondition(index == .end, "Index out of bounds")
		
		let matchesOfAssertedPattern = assertedPattern.forwardMatches(enteringFrom: baseMatch)
		let indexOfFirstMatchOfAssertedPattern = matchesOfAssertedPattern.startIndex
		
		precondition(indexOfFirstMatchOfAssertedPattern != matchesOfAssertedPattern.endIndex, "Index out of bounds")
		return .some(innerIndex: indexOfFirstMatchOfAssertedPattern)
		
	}
	
	public func index(after index: Index) -> Index {
		precondition(index != .end, "Index out of bounds")
		return .end
	}
	
}

extension ForwardAssertionMatchCollection.Index : Comparable {
	public static func <(leftIndex: Self, rightIndex: Self) -> Bool {
		if case (.some, .end) = (leftIndex, rightIndex) {
			return true
		} else {
			return false
		}
	}
}
