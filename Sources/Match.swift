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
	
	/// The position in the collection up to where matching has been performed and from where further matching has to be done.
	///
	/// The input position is equal to `matchingCollection.startIndex` before any matching has done and equal to `matchingCollection.endIndex` when the complete collection has been consumed.
	public private(set) var inputPosition: Collection.Index
	
	/// The range of indices that has already been matched.
	///
	/// - Invariant: `matchingCollection.contains(completedRange)`
	public var completedRange: Range<Collection.Index> {
		return matchingCollection.startIndex..<inputPosition
	}
	
	/// The range of indices that remains to be matched.
	///
	/// A pattern that cannot match any subsequence within its entry state's remaining range cannot produce successor states (which results in backtracking of the pattern matcher).
	///
	/// - Invariant: `matchingCollection.contains(remainingRange)`
	public var remainingRange: Range<Collection.Index> {
		return inputPosition..<matchingCollection.endIndex
	}
	
	/// The subsequence of the collection that remains to be matched.
	///
	/// A pattern that cannot match any subsequence within its entry state's remaining collection cannot produce successor states (which results in backtracking of the pattern matcher).
	///
	/// - Invariant: `matchingCollection.contains(remainingIndex)`
	public var remainingCollection: Collection.SubSequence {
		return matchingCollection[remainingRange]
	}
	
	/// Moves the input position forward over a given range, ensuring not to skip any subsequence.
	///
	/// - Requires: The range begins exactly at the input position, i.e., `range.lowerBound == remainingRange.lowerBound`.
	/// - Requires: The range ends before or at the collection's end index, i.e., `range.upperBound <= remainingRange.upperBound`.
	///
	/// - Postcondition: `remainingIndex.lowerBound == range.upperBound`
	///
	/// - Parameter range: The range over which to move the input position.
	public mutating func advanceInputPosition(over range: Range<Collection.Index>) {
		precondition(range.lowerBound == remainingRange.lowerBound, "Skipped over subsequence")
		precondition(range.upperBound <= remainingRange.upperBound, "Input position out of bounds")
		inputPosition = range.upperBound
	}
	
	/// Returns a match whose input position is moved forward over a given range, ensuring not to skip any subsequence.
	///
	/// - Requires: The range begins exactly at the input position, i.e., `range.lowerBound == remainingRange.lowerBound`.
	/// - Requires: The range ends before or at the collection's end index, i.e., `range.upperBound <= remainingRange.upperBound`.
	///
	/// - Parameter range: The range over which to move the input position.
	///
	/// - Returns: A match whose input position is moved forward over `range`.
	public func advancingInputPosition(over range: Range<Collection.Index>) -> Match {
		var match = self
		match.advanceInputPosition(over: range)
		return match
	}
	
	/// Moves the input position forward over a given distance.
	///
	/// - Requires: `distance >= 0`
	/// - Requires: The new input position does not exceed the collection's bounds.
	///
	/// - Parameter distance: The distance over which to move the input position.
	public mutating func advanceInputPosition(distance: Collection.IndexDistance) {
		precondition(distance >= 0, "Negative distance")
		matchingCollection.formIndex(&inputPosition, offsetBy: distance)
	}
	
	/// Returns a match whose input position is moved forward over a given distance.
	///
	/// - Requires: `distance >= 0`
	/// - Requires: The new input position does not exceed the collection's bounds.
	///
	/// - Parameter distance: The distance over which to move the input position.
	///
	/// - Returns: A match whose input position is moved forward over `distance`.
	public func advancingInputPosition(distance: Collection.IndexDistance) -> Match {
		var match = self
		match.advanceInputPosition(distance: distance)
		return match
	}
	
	/// The captured ranges, by the token that captured them.
	private var capturedRangesByToken: [ObjectIdentifier : Range<Collection.Index>]
	
	/// Captures a range for a token.
	///
	/// - Requires: `capturedRange(for: token) == nil`
	///
	/// - Postcondition: `capturedRange(for: token) == range`
	///
	/// - Parameter range: The captured range.
	/// - Parameter token: The token that captured the range.
	internal mutating func capture<P : Pattern>(_ range: Range<Collection.Index>, for token: Token<P>) {
		let previousRange = capturedRangesByToken.updateValue(range, forKey: ObjectIdentifier(token))
		precondition(previousRange == range || previousRange == nil, "Multiple distinct captures for token")
	}
	
	/// Returns a match with a range captured for a token.
	///
	/// - Requires: `capturedRange(for: token) == nil`
	///
	/// - Parameter range: The captured range.
	/// - Parameter token: The token that captured the range.
	///
	/// - Returns: A match where `capturedRange(for: token) == range`.
	internal func capturing<P : Pattern>(_ range: Range<Collection.Index>, for token: Token<P>) -> Match {
		var match = self
		match.capture(range, for: token)
		return match
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
