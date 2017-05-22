// PatternKit © 2017 Constantino Tsarouhas

/// An iterator of matches of a concatenation.
public struct ConcatenationMatchIterator<FirstPattern : Pattern, SecondPattern : Pattern> where FirstPattern.Collection == SecondPattern.Collection {
	
	public init(firstPattern: FirstPattern, secondPattern: SecondPattern, baseMatch: Match<FirstPattern.Collection>, direction: MatchingDirection) {
		self.firstPattern = firstPattern
		self.secondPattern = secondPattern
		self.baseMatch = baseMatch
		self.direction = direction
		self.state = State(firstPattern: firstPattern, secondPattern: secondPattern, baseMatch: baseMatch, direction: direction)
	}
	
	/// The pattern that matches the first part of the concatenation in the direction of matching.
	public let firstPattern: FirstPattern
	
	/// The pattern that matches the part after the part matched by the leading pattern, in the direction of matching.
	public let secondPattern: SecondPattern
	
	/// The base match.
	public let baseMatch: Match<FirstPattern.Collection>
	
	/// The direction of matching.
	public let direction: MatchingDirection
	
	/// The iterator's state, or `nil` if the iterator is exhausted.
	///
	/// The state is updated with each call to `next()`. The result value of `next()` is based on the state before the call.
	public fileprivate(set) var state: State?
	
	public struct State {
		
		/// Creates an initial state.
		///
		/// - Returns: An initial state, or `nil` if no match could be generated from the patterns.
		fileprivate init?(firstPattern: FirstPattern, secondPattern: SecondPattern, baseMatch: Match<FirstPattern.Collection>, direction: MatchingDirection) {
			
			self.iteratorOfFirstPattern = firstPattern.matches(base: baseMatch, direction: direction)
			guard let matchOfFirstPattern = iteratorOfFirstPattern.next() else { return nil }
			self.matchOfFirstPattern = matchOfFirstPattern
			
			self.iteratorOfSecondPattern = secondPattern.matches(base: matchOfFirstPattern, direction: direction)
			guard let matchOfSecondPattern = iteratorOfSecondPattern.next() else { return nil }
			self.matchOfSecondPattern = matchOfSecondPattern
			
		}
		
		/// The currently applied match of the first pattern.
		public fileprivate(set) var matchOfFirstPattern: Match<FirstPattern.Collection>
		
		/// The iterator of the first pattern.
		fileprivate let iteratorOfFirstPattern: AnyIterator<Match<FirstPattern.Collection>>
		
		/// The currently applied match of the second pattern.
		///
		/// A match of the second pattern is also a match of the concatenation.
		public fileprivate(set) var matchOfSecondPattern: Match<SecondPattern.Collection>
		
		/// The iterator of the second pattern.
		fileprivate var iteratorOfSecondPattern: AnyIterator<Match<SecondPattern.Collection>>
		
	}
	
	/// Updates the state.
	fileprivate mutating func updateState() {
		
		guard var state = state else { return }
		
		if let nextMatchOfSecondPattern = state.iteratorOfSecondPattern.next() {
			state.matchOfSecondPattern = nextMatchOfSecondPattern
			self.state = state
		} else if let nextMatchOfFirstPattern = state.iteratorOfFirstPattern.next() {
			state.matchOfFirstPattern = nextMatchOfFirstPattern
			state.iteratorOfSecondPattern = secondPattern.matches(base: nextMatchOfFirstPattern, direction: direction)
			self.state = state
			updateState()
		} else {
			self.state = nil
		}
		
	}
	
}

extension ConcatenationMatchIterator : IteratorProtocol {
	
	public mutating func next() -> Match<FirstPattern.Collection>? {
		defer { updateState() }
		return state?.matchOfSecondPattern
	}
	
}
