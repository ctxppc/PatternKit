// PatternKit © 2017 Constantino Tsarouhas

/// A conformance of a collection to a pattern.
public struct Match<Collection : BidirectionalCollection> /* where Collection.Iterator.Element : Equatable */ {	// TODO: Add in Swift 4
	
	/// Creates a match for matching patterns on some collection, starting from the collection's first element.
	///
	/// - Parameter collection: The collection on which the match applies.
	internal init(for collection: Collection) {
		matchingCollection = collection
		inputPosition = collection.startIndex
		capturedRangesByToken = [:]
	}
	
	/// Creates a match that resumes matching from a match, but with additional captures from another match.
	///
	/// This initialiser can be used by patterns that don't advance the input position but do need to perform matching on a different range, like forward and backward assertions.
	///
	/// - Requires: For every captured token `token` in both `resumingMatch` and `capturesMatch`, `resumingMatch.capturedRange(for: token) == capturesMatch.capturedRange(for: token)`.
	/// - Requires: `resumingMatch.matchingCollection == capturesMatch.matchingCollection`, if `Collection` conforms to `Equatable`. This constraint is currently *not* enforced.
	///
	/// - Parameter resumingMatch: The match from where to resume matching.
	/// - Parameter capturesMatch: The match whose captures to merge with `resumingMatch`.
	public init(resumingFrom resumingMatch: Match, withCapturesFrom capturesMatch: Match) {
		
		self = resumingMatch
		
		for (token, newRange) in capturesMatch.capturedRangesByToken {
			let previousRange = capturedRangesByToken.updateValue(newRange, forKey: token)
			precondition(previousRange == nil || previousRange == newRange, "Multiple distinct captures for token")
		}
		
	}
	
	/// The collection on which the match applies.
	public let matchingCollection: Collection
	
	/// The position in the matching collection that,
	/// * within the context of forward matching, represents the next element (if any) to be matched, and
	/// * within the context of backward matching, represents the previous element (if any) that has been matched (in the direction of matching).
	///
	/// The collection is fully matched if the input position equals `matchingCollection.endIndex` during forward matching, and `matchingCollection.startIndex` during backward matching.
	///
	/// - Invariant: `matchingCollection.indices.contains(inputPosition)`
	public private(set) var inputPosition: Collection.Index
	
	/// Returns a range of indices representing the elements that are yet to be matched.
	///
	/// - Parameter direction: The direction in which matching occurs.
	///
	/// - Returns: A range of indices representing the elements that are yet to be matched.
	public func remainingIndices(direction: MatchingDirection) -> Range<Collection.Index> {
		switch direction {
			case .forward:	return inputPosition..<matchingCollection.endIndex
			case .backward:	return matchingCollection.startIndex..<inputPosition
		}
	}
	
	/// Returns a range of indices representing the elements that have already been matched.
	///
	/// - Parameter direction: The direction in which matching occurs.
	///
	/// - Returns: A range of indices representing the elements that have already been matched.
	public func completedIndices(direction: MatchingDirection) -> Range<Collection.Index> {
		switch direction {
			case .forward:	return matchingCollection.startIndex..<inputPosition
			case .backward:	return inputPosition..<matchingCollection.endIndex
		}
	}
	
	/// Returns the elements that are yet to be matched.
	///
	/// - Parameter direction: The direction in which matching occurs.
	///
	/// - Returns: The elements that are yet to be matched.
	public func remainingElements(direction: MatchingDirection) -> Collection.SubSequence {
		return matchingCollection[remainingIndices(direction: direction)]
	}
	
	/// Returns the elements that have already been matched.
	///
	/// - Parameter direction: The direction in which matching occurs.
	///
	/// - Returns: The elements that have already been matched.
	public func matchedElements(direction: MatchingDirection) -> Collection.SubSequence {
		return matchingCollection[completedIndices(direction: direction)]
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
	public mutating func matchElements(at range: ClosedRange<Collection.Index>, direction: MatchingDirection) {
		switch direction {
			
			case .forward:
			precondition(range.lowerBound == inputPosition, "Skipped over subsequence")
			precondition(range.upperBound < matchingCollection.endIndex, "Input position out of bounds")
			inputPosition = matchingCollection.index(after: range.upperBound)
			
			case .backward:
			precondition(range.lowerBound >= matchingCollection.startIndex, "Input position out of bounds")
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
	public func matchingElements(at range: ClosedRange<Collection.Index>, direction: MatchingDirection) -> Match {
		return withCopy(of: self, mutator: Match.matchElements(at:direction:), arguments: range, direction)
	}
	
	/// Moves the input position forward or backward over a given distance.
	///
	/// - Requires: The new input position does not exceed the collection's bounds.
	/// - Requires: `distance >= 0`
	///
	/// - Parameter distance: The (absolute) distance over which to move the input position.
	/// - Parameter direction: The direction.
	public mutating func moveInputPosition(distance: Collection.IndexDistance, direction: MatchingDirection) {
		precondition(distance >= 0, "Negative absolute distance.")
		switch direction {
			case .forward:	matchingCollection.formIndex(&inputPosition, offsetBy: distance)
			case .backward:	matchingCollection.formIndex(&inputPosition, offsetBy: -distance)
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
	public func movingInputPosition(distance: Collection.IndexDistance, direction: MatchingDirection) -> Match {
		return withCopy(of: self, mutator: Match.moveInputPosition, arguments: distance, direction)
	}
	
	/// The captured ranges, by the token that captured them.
	private var capturedRangesByToken: [ObjectIdentifier : Range<Collection.Index>]
	
	/// Captures a range for a token.
	///
	/// - Requires: The range is within the collection's bounds.
	/// - Requires: `capturedRange(for: token) == nil`
	///
	/// - Postcondition: `capturedRange(for: token) == range`
	///
	/// - Parameter range: The captured range.
	/// - Parameter token: The token that captured the range.
	internal mutating func capture<P : Pattern>(_ range: Range<Collection.Index>, for token: Token<P>) {
		precondition((matchingCollection.startIndex..<matchingCollection.endIndex).contains(range), "Captured range out of bounds")
		let previousRange = capturedRangesByToken.updateValue(range, forKey: ObjectIdentifier(token))
		precondition(previousRange == range || previousRange == nil, "Multiple distinct captures for token")
	}
	
	/// Returns a match with a range captured for a token.
	///
	/// - Requires: The range is within the collection's bounds.
	/// - Requires: `capturedRange(for: token) == nil`
	///
	/// - Parameter range: The captured range.
	/// - Parameter token: The token that captured the range.
	///
	/// - Returns: A match where `capturedRange(for: token) == range`.
	internal func capturing<P : Pattern>(_ range: Range<Collection.Index>, for token: Token<P>) -> Match {
		return withCopy(of: self, mutator: Match.capture(_:for:), arguments: range, token)
	}
	
	/// Returns the range captured by a token.
	///
	/// - Parameter token: The token.
	///
	/// - Returns: The range captured by `token`, or `nil` if no such range has been captured.
	public func capturedRange<P : Pattern>(for token: Token<P>) -> Range<Collection.Index>? {
		return capturedRangesByToken[ObjectIdentifier(token)]
	}
	
	/// Returns the subsequence captured by a token.
	///
	/// - Parameter token: The token.
	///
	/// - Returns: The subsequence captured by `token`, or `nil` if no such subsequence has been captured.
	public func capturedSubsequence<P : Pattern>(for token: Token<P>) -> Collection.SubSequence? {
		guard let range = capturedRange(for: token) else { return nil }
		return matchingCollection[range]
	}
	
}

internal func none<Collection : BidirectionalCollection>() -> AnyIterator<Match<Collection>> {
	return AnyIterator { nil }
}

internal func one<Collection : BidirectionalCollection>(_ match: Match<Collection>) -> AnyIterator<Match<Collection>> {
	return AnyIterator([match].makeIterator())
}
