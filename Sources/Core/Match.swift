// PatternKit © 2017–19 Constantino Tsarouhas

import DepthKit

/// A conformance of a collection to a pattern.
public struct Match<Subject : BidirectionalCollection> where Subject.Element : Equatable {
	
	/// Creates an initial match for matching over some subject.
	///
	/// - Postcondition: `remainingElements(direction: direction) == subject`
	///
	/// - Parameter subject: The collection over which the match applies.
	/// - Parameter direction: The direction in which matching is to be performed. The default is forward matching.
	public init(over subject: Subject, direction: MatchingDirection = .forward) {
		switch direction {
			case .forward:	self.init(over: subject, inputPosition: subject.startIndex)
			case .backward:	self.init(over: subject, inputPosition: subject.endIndex)
		}
	}
	
	/// Creates a match for matching over some subject with given starting input position.
	///
	/// - Requires: `inputPosition` is a valid index into `subject`.
	///
	/// - Parameter subject: The collection over which the match applies.
	/// - Parameter inputPosition: The input position.
	public init(over subject: Subject, inputPosition: Subject.Index) {
		self.subject = subject
		self.inputPosition = inputPosition
		capturedRangesByToken = [:]
	}
	
	/// The collection over which the match applies.
	public let subject: Subject
	
	/// The position in the subject collection that,
	/// * within the context of forward matching, represents the next element (if any) to be matched, and
	/// * within the context of backward matching, represents the previous element (if any) that has been matched (in the direction of matching).
	///
	/// The collection is fully matched if the input position equals `subject.endIndex` during forward matching, and `subject.startIndex` during backward matching.
	///
	/// - Invariant: `subject.indices.contains(inputPosition)`
	public private(set) var inputPosition: Subject.Index
	
	/// Returns a range of indices representing the elements that are yet to be matched.
	///
	/// - Parameter direction: The direction in which matching occurs.
	///
	/// - Returns: A range of indices representing the elements that are yet to be matched.
	public func remainingIndices(direction: MatchingDirection) -> Range<Subject.Index> {
		switch direction {
			case .forward:	return inputPosition..<subject.endIndex
			case .backward:	return subject.startIndex..<inputPosition
		}
	}
	
	/// Returns a range of indices representing the elements that have already been matched.
	///
	/// - Parameter direction: The direction in which matching occurs.
	///
	/// - Returns: A range of indices representing the elements that have already been matched.
	public func completedIndices(direction: MatchingDirection) -> Range<Subject.Index> {
		switch direction {
			case .forward:	return subject.startIndex..<inputPosition
			case .backward:	return inputPosition..<subject.endIndex
		}
	}
	
	/// Returns the elements that are yet to be matched.
	///
	/// - Parameter direction: The direction in which matching occurs.
	///
	/// - Returns: The elements that are yet to be matched.
	public func remainingElements(direction: MatchingDirection) -> Subject.SubSequence {
		return subject[remainingIndices(direction: direction)]
	}
	
	/// Returns the elements that have already been matched.
	///
	/// - Parameter direction: The direction in which matching occurs.
	///
	/// - Returns: The elements that have already been matched.
	public func matchedElements(direction: MatchingDirection) -> Subject.SubSequence {
		return subject[completedIndices(direction: direction)]
	}
	
	/// Marks elements at a given range as matched.
	///
	/// - Requires: If matching forward, the range begins at the input position. If matching backward, the range ends at the input position.
	/// - Requires: The range is within the collection's bounds.
	///
	/// - Postcondition: `completedIndices(direction: direction).contains(range)`
	///
	/// - Parameter range: The range representing the elements that have been matched.
	/// - Parameter direction: The direction in which matching occurs.
	public mutating func matchElements(at range: ClosedRange<Subject.Index>, direction: MatchingDirection) {
		switch direction {
			
			case .forward:
			precondition(range.lowerBound == inputPosition, "Skipped over subsequence")
			precondition(range.upperBound < subject.endIndex, "Input position out of bounds")
			inputPosition = subject.index(after: range.upperBound)
			
			case .backward:
			precondition(range.lowerBound >= subject.startIndex, "Input position out of bounds")
			precondition(range.upperBound < inputPosition, "Skipped over subsequence")
			inputPosition = range.lowerBound
			
		}
	}
	
	/// Returns a match elements at a given range are marked as matched.
	///
	/// - Requires: If matching forward, the range begins at the input position. If matching backward, the range ends at the input position.
	/// - Requires: The range is within the collection's bounds.
	///
	/// - Parameter range: The range representing the elements that have been matched.
	/// - Parameter direction: The direction in which matching occurs.
	///
	/// - Postcondition: A match where `completedIndices(direction: direction).contains(range)`.
	public func matchingElements(at range: ClosedRange<Subject.Index>, direction: MatchingDirection) -> Match {
		var match = self
		match.matchElements(at: range, direction: direction)
		return match
	}
	
	/// Moves the input position forward or backward over a given distance.
	///
	/// - Requires: The new input position does not exceed the collection's bounds.
	/// - Requires: `distance >= 0`
	///
	/// - Parameter distance: The (absolute) distance over which to move the input position.
	/// - Parameter direction: The direction.
	public mutating func moveInputPosition(distance: Int, direction: MatchingDirection) {
		precondition(distance >= 0, "Negative absolute distance.")
		switch direction {
			case .forward:	subject.formIndex(&inputPosition, offsetBy: distance)
			case .backward:	subject.formIndex(&inputPosition, offsetBy: -distance)
		}
	}
	
	/// Returns a match whose input position is moved forward or backward over a given distance.
	///
	/// - Requires: The new input position does not exceed the collection's bounds.
	/// - Requires: `distance >= 0`
	///
	/// - Parameter distance: The (absolute) distance over which to move the input position.
	/// - Parameter direction: The direction.
	///
	/// - Returns: A match whose input position is moved over `distance`.
	public func movingInputPosition(distance: Int, direction: MatchingDirection) -> Match {
		var match = self
		match.moveInputPosition(distance: distance, direction: direction)
		return match
	}
	
	/// Returns a match whose input position is set to the input position of a given match.
	///
	/// - Requires: `self.subject == other.subject`, as if `Collection` were to be `Equatable`.
	///
	/// - Parameter other: The match from where to resume.
	///
	/// - Returns: A copy of `self` such that `inputPosition = other.inputPosition`.
	public func resuming(from other: Match) -> Match {
		var result = self
		result.inputPosition = other.inputPosition
		return result
	}
	
	/// The captured ranges, by the token that captured them.
	private var capturedRangesByToken: [ObjectIdentifier : [Range<Subject.Index>]]
	
	/// Captures a range for a token.
	///
	/// - Requires: The range is within the collection's bounds.
	///
	/// - Postcondition: `capturedRanges(for: token).last == range`
	///
	/// - Parameter range: The captured range.
	/// - Parameter token: The token that captured the range.
	internal mutating func capture<P>(_ range: Range<Subject.Index>, for token: Token<P>) {
		
		precondition((subject.startIndex..<subject.endIndex).contains(range), "Captured range out of bounds")
		
		let token = ObjectIdentifier(token)
		if let previousArray = capturedRangesByToken[token] {
			capturedRangesByToken[token] = previousArray + [range]
		} else {
			capturedRangesByToken[token] = [range]
		}
		
	}
	
	/// Returns a match with a range captured for a token.
	///
	/// - Requires: The range is within the collection's bounds.
	///
	/// - Parameter range: The captured range.
	/// - Parameter token: The token that captured the range.
	///
	/// - Returns: A match where `capturedRanges(for: token).last == range`.
	internal func capturing<P>(_ range: Range<Subject.Index>, for token: Token<P>) -> Match {
		var match = self
		match.capture(range, for: token)
		return match
	}
	
	/// Returns the ranges captured by a token.
	///
	/// - Parameter token: The token.
	///
	/// - Returns: The ranges captured by `token`.
	public func capturedRanges<P>(for token: Token<P>) -> [Range<Subject.Index>] {
		return capturedRangesByToken[ObjectIdentifier(token)] ?? []
	}
	
	/// Returns the subsequences captured by a token.
	///
	/// - Parameter token: The token.
	///
	/// - Returns: The subsequences captured by `token`.
	public func capturedSubsequences<P>(for token: Token<P>) -> [Subject.SubSequence] {
		return capturedRanges(for: token).map { subject[$0] }
	}
	
}
