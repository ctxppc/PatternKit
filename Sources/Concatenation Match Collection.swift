// PatternKit © 2017 Constantino Tsarouhas

/// A collection of matches of a concatenation pattern.
public struct ConcatenationMatchCollection<LeadingPattern : Pattern, TrailingPattern : Pattern> where
	LeadingPattern.Subject == TrailingPattern.Subject,
	LeadingPattern.MatchCollection.Iterator.Element == Match<LeadingPattern.Subject>,
	TrailingPattern.MatchCollection.Iterator.Element == Match<TrailingPattern.Subject>,
	LeadingPattern.MatchCollection.Indices == DefaultBidirectionalIndices<LeadingPattern.MatchCollection>,
	TrailingPattern.MatchCollection.Indices == DefaultBidirectionalIndices<TrailingPattern.MatchCollection> {		// TODO: Update constraints when better Collection constraints land, in Swift 4
	
	public typealias Subject = LeadingPattern.Subject
	
	/// Creates a concatenation match pattern.
	///
	/// - Parameter leadingPattern: The matches of the first part of the concatenation.
	/// - Parameter trailingPattern: The matches of the part after the part matched by the leading pattern.
	/// - Parameter baseMatch: The base match.
	/// - Parameter direction: The direction of matching.
	internal init(leadingPattern: LeadingPattern, trailingPattern: TrailingPattern, baseMatch: Match<Subject>, direction: MatchingDirection) {
		self.leadingPattern = leadingPattern
		self.trailingPattern = trailingPattern
		self.baseMatch = baseMatch
		self.direction = direction
	}
	
	/// The pattern matching the first part of the concatenation.
	public let leadingPattern: LeadingPattern
	
	/// The pattern matching the part after the part matched by the leading pattern.
	public let trailingPattern: TrailingPattern
	
	/// The base match.
	public let baseMatch: Match<Subject>
	
	/// The direction of matching.
	///
	/// If `forward`, the concatenation match collection first matches the leading pattern forwards from the base match's input position, and then matches the trailing pattern forwards from the input position of every match generated by the leading pattern.
	///
	/// If `backward`, the concatenation match collection first matches the trailing pattern backwards from the base match's input position, and then matches the leading pattern backwards from the input position of every match generated by the trailing pattern.
	public let direction: MatchingDirection
	
}

extension ConcatenationMatchCollection : BidirectionalCollection {
	
	public typealias Index = ConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>
	
	public var startIndex: Index {
		switch direction {
			
			case .forward: do {
				
				let matchesOfLeadingPattern = leadingPattern.matches(base: baseMatch, direction: direction) as LeadingPattern.MatchCollection
				for (candidateIndexOfLeadingPattern, candidateMatchOfLeadingPattern) in zip(matchesOfLeadingPattern.indices, matchesOfLeadingPattern) {
					let matchesOfTrailingPattern = trailingPattern.matches(base: candidateMatchOfLeadingPattern, direction: direction) as TrailingPattern.MatchCollection
					let candidateIndexOfTrailingPattern = matchesOfTrailingPattern.startIndex
					if candidateIndexOfTrailingPattern != matchesOfTrailingPattern.endIndex {
						return .some(indexForLeadingPattern: candidateIndexOfLeadingPattern, indexForTrailingPattern: candidateIndexOfTrailingPattern, direction: direction)
					}
				}
				
				return .end
				
			}
			
			case .backward: do {
			
				let matchesOfTrailingPattern = trailingPattern.matches(base: baseMatch, direction: direction) as TrailingPattern.MatchCollection
				for (candidateIndexOfTrailingPattern, candidateMatchOfTrailingPattern) in zip(matchesOfTrailingPattern.indices, matchesOfTrailingPattern) {
					let matchesOfLeadingPattern = leadingPattern.matches(base: candidateMatchOfTrailingPattern, direction: direction) as LeadingPattern.MatchCollection
					let candidateIndexOfLeadingPattern = matchesOfLeadingPattern.startIndex
					if candidateIndexOfLeadingPattern != matchesOfLeadingPattern.endIndex {
						return .some(indexForLeadingPattern: candidateIndexOfLeadingPattern, indexForTrailingPattern: candidateIndexOfTrailingPattern, direction: direction)
					}
				}
				
				return .end
			
			}
			
		}
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> Match<Subject> {
		
		guard case .some(indexForLeadingPattern: let indexForLeadingPattern, indexForTrailingPattern: let indexForTrailingPattern, direction: _) = index else { preconditionFailure("Index out of bounds") }
		
		switch direction {
			
			case .forward:
			let matchOfLeadingPattern = (leadingPattern.matches(base: baseMatch, direction: direction) as LeadingPattern.MatchCollection)[indexForLeadingPattern]
			return (trailingPattern.matches(base: matchOfLeadingPattern, direction: direction) as TrailingPattern.MatchCollection)[indexForTrailingPattern]
			
			case .backward:
			let matchOfTrailingPattern = (trailingPattern.matches(base: baseMatch, direction: direction) as TrailingPattern.MatchCollection)[indexForTrailingPattern]
			return (leadingPattern.matches(base: matchOfTrailingPattern, direction: direction) as LeadingPattern.MatchCollection)[indexForLeadingPattern]
			
		}
		
	}
	
	public func index(before index: Index) -> Index {
		switch direction {
			
			case .forward: do {
				
				let matchesOfLeadingPattern = leadingPattern.matches(base: baseMatch, direction: direction) as LeadingPattern.MatchCollection
				let matchesOfTrailingPattern: TrailingPattern.MatchCollection
				let indexForLeadingPattern: LeadingPattern.MatchCollection.Index	// is never endIndex
				let indexForTrailingPattern: TrailingPattern.MatchCollection.Index	// may be endIndex
				
				switch index {
					
					case .some(indexForLeadingPattern: let ilp, indexForTrailingPattern: let itp, direction: _):
					indexForLeadingPattern = ilp
					indexForTrailingPattern = itp
					matchesOfTrailingPattern = trailingPattern.matches(base: matchesOfLeadingPattern[indexForLeadingPattern], direction: direction)
					
					case .end:
					precondition(matchesOfLeadingPattern.startIndex != matchesOfLeadingPattern.endIndex, "Index out of bounds")
					indexForLeadingPattern = matchesOfLeadingPattern.index(before: matchesOfLeadingPattern.endIndex)
					matchesOfTrailingPattern = trailingPattern.matches(base: matchesOfLeadingPattern[indexForLeadingPattern], direction: direction)
					indexForTrailingPattern = matchesOfTrailingPattern.endIndex
					
				}
				
				if indexForTrailingPattern > matchesOfTrailingPattern.startIndex {
					return .some(indexForLeadingPattern: indexForLeadingPattern, indexForTrailingPattern: matchesOfTrailingPattern.index(before: indexForTrailingPattern), direction: direction)
				}
				
				for candidateIndexOfLeadingPattern in matchesOfLeadingPattern.indices.prefix(upTo: indexForLeadingPattern).reversed() {		// index range excludes indexForLeadingPattern, includes (and ends at) startIndex
					let matchesOfTrailingPattern = trailingPattern.matches(base: matchesOfLeadingPattern[candidateIndexOfLeadingPattern], direction: direction) as TrailingPattern.MatchCollection
					if matchesOfTrailingPattern.startIndex != matchesOfTrailingPattern.endIndex {
						return .some(indexForLeadingPattern: candidateIndexOfLeadingPattern, indexForTrailingPattern: matchesOfTrailingPattern.startIndex, direction: direction)
					}
				}
				
				preconditionFailure("Index out of bounds")
				
			}
				
			case .backward: do {
				
				let matchesOfTrailingPattern = trailingPattern.matches(base: baseMatch, direction: direction) as TrailingPattern.MatchCollection
				let matchesOfLeadingPattern: LeadingPattern.MatchCollection
				let indexForTrailingPattern: TrailingPattern.MatchCollection.Index	// is never endIndex
				let indexForLeadingPattern: LeadingPattern.MatchCollection.Index	// may be endIndex
				
				switch index {
					
					case .some(indexForLeadingPattern: let ilp, indexForTrailingPattern: let itp, direction: _):
					indexForTrailingPattern = itp
					indexForLeadingPattern = ilp
					matchesOfLeadingPattern = leadingPattern.matches(base: matchesOfTrailingPattern[indexForTrailingPattern], direction: direction)
					
					case .end:
					precondition(matchesOfTrailingPattern.startIndex != matchesOfTrailingPattern.endIndex, "Index out of bounds")
					indexForTrailingPattern = matchesOfTrailingPattern.index(before: matchesOfTrailingPattern.endIndex)
					matchesOfLeadingPattern = leadingPattern.matches(base: matchesOfTrailingPattern[indexForTrailingPattern], direction: direction)
					indexForLeadingPattern = matchesOfLeadingPattern.endIndex
					
				}
				
				if indexForLeadingPattern > matchesOfLeadingPattern.startIndex {
					return .some(indexForLeadingPattern: matchesOfLeadingPattern.index(before: indexForLeadingPattern), indexForTrailingPattern: indexForTrailingPattern, direction: direction)
				}
				
				for candidateIndexOfTrailingPattern in matchesOfTrailingPattern.indices.prefix(upTo: indexForTrailingPattern).reversed() {	// index range excludes indexForLeadingPattern, includes (and ends at) startIndex
					let matchesOfLeadingPattern = leadingPattern.matches(base: matchesOfTrailingPattern[candidateIndexOfTrailingPattern], direction: direction) as LeadingPattern.MatchCollection
					if matchesOfLeadingPattern.startIndex != matchesOfLeadingPattern.endIndex {
						return .some(indexForLeadingPattern: matchesOfLeadingPattern.startIndex, indexForTrailingPattern: candidateIndexOfTrailingPattern, direction: direction)
					}
				}
				
				preconditionFailure("Index out of bounds")
				
			}
			
		}
	}
	
	public func index(after index: Index) -> Index {
		switch direction {
			
			case .forward: do {
				
				guard case .some(indexForLeadingPattern: let indexForLeadingPattern, indexForTrailingPattern: let indexForTrailingPattern, direction: _) = index else { preconditionFailure("Index out of bounds") }
				let matchesOfLeadingPattern = leadingPattern.matches(base: baseMatch, direction: direction) as LeadingPattern.MatchCollection
				let matchesOfTrailingPattern = trailingPattern.matches(base: matchesOfLeadingPattern[indexForLeadingPattern], direction: direction) as TrailingPattern.MatchCollection
				
				let nextIndexOfTrailingPattern = matchesOfTrailingPattern.index(after: indexForTrailingPattern)
				if nextIndexOfTrailingPattern < matchesOfTrailingPattern.endIndex {
					return .some(indexForLeadingPattern: indexForLeadingPattern, indexForTrailingPattern: nextIndexOfTrailingPattern, direction: direction)
				}
				
				let nextIndexOfLeadingPattern = matchesOfLeadingPattern.index(after: indexForLeadingPattern)
				guard nextIndexOfLeadingPattern < matchesOfLeadingPattern.endIndex else { return .end }
				
				for nextIndexOfLeadingPattern in matchesOfLeadingPattern.indices.suffix(from: nextIndexOfLeadingPattern) {	// index range includes nextIndexOfLeadingPattern, excludes endIndex
					let matchesOfTrailingPattern = trailingPattern.matches(base: matchesOfLeadingPattern[nextIndexOfLeadingPattern], direction: direction) as TrailingPattern.MatchCollection
					if matchesOfTrailingPattern.startIndex != matchesOfTrailingPattern.endIndex {
						return .some(indexForLeadingPattern: nextIndexOfLeadingPattern, indexForTrailingPattern: matchesOfTrailingPattern.startIndex, direction: direction)
					}
				}
				
				return .end
				
			}
			
			case .backward: do {
				
				guard case .some(indexForLeadingPattern: let indexForLeadingPattern, indexForTrailingPattern: let indexForTrailingPattern, direction: _) = index else { preconditionFailure("Index out of bounds") }
				let matchesOfTrailingPattern = trailingPattern.matches(base: baseMatch, direction: direction) as TrailingPattern.MatchCollection
				let matchesOfLeadingPattern = leadingPattern.matches(base: matchesOfTrailingPattern[indexForTrailingPattern], direction: direction) as LeadingPattern.MatchCollection
				
				let nextIndexForLeadingPattern = matchesOfLeadingPattern.index(after: indexForLeadingPattern)
				if nextIndexForLeadingPattern < matchesOfLeadingPattern.endIndex {
					return .some(indexForLeadingPattern: nextIndexForLeadingPattern, indexForTrailingPattern: indexForTrailingPattern, direction: direction)
				}
				
				let nextIndexOfTrailingPattern = matchesOfTrailingPattern.index(after: indexForTrailingPattern)
				guard nextIndexOfTrailingPattern < matchesOfTrailingPattern.endIndex else { return .end }
				
				for nextIndexOfTrailingPattern in matchesOfTrailingPattern.indices.suffix(from: nextIndexOfTrailingPattern) {	// index range includes nextIndexOfTrailingPattern, excludes endIndex
					let matchesOfLeadingPattern = leadingPattern.matches(base: matchesOfTrailingPattern[nextIndexOfTrailingPattern], direction: direction) as LeadingPattern.MatchCollection
					if matchesOfLeadingPattern.startIndex != matchesOfLeadingPattern.endIndex {
						return .some(indexForLeadingPattern: matchesOfLeadingPattern.startIndex, indexForTrailingPattern: nextIndexOfTrailingPattern, direction: direction)
					}
				}
				
				return .end
				
			}
			
		}
	}
	
}

public enum ConcatenationMatchCollectionIndex<LeadingPattern : Pattern, TrailingPattern : Pattern> where LeadingPattern.Subject == TrailingPattern.Subject {
	
	/// A position to a valid match.
	///
	/// - Invariant: `indexForLeadingPattern` is not equal to `endIndex` of the leading pattern's match collection, and `indexForTrailingPattern` is not equal to `endIndex` of the trailing pattern's match collection.
	///
	/// - Parameter indexForLeadingPattern: The index within the leading pattern's match collection.
	/// - Parameter indexForTrailingPattern: The index within the trailing pattern's match collection.
	/// - Parameter direction: The direction in which the index is ordered.
	case some(indexForLeadingPattern: LeadingPattern.MatchCollection.Index, indexForTrailingPattern: TrailingPattern.MatchCollection.Index, direction: MatchingDirection)
	
	/// The position after the last element of the match collection.
	case end
	
}

extension ConcatenationMatchCollectionIndex : Comparable {
	
	public static func <<LeadingPattern, TrailingPattern>(leftIndex: ConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>, rightIndex: ConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>) -> Bool {
		switch (leftIndex, rightIndex) {
			
			case (.some(indexForLeadingPattern: let leadingLeft, indexForTrailingPattern: let trailingLeft, direction: .forward), .some(indexForLeadingPattern: let leadingRight, indexForTrailingPattern: let trailingRight, direction: .forward)):
			return (leadingLeft, trailingLeft) < (leadingRight, trailingRight)
			
			case (.some(indexForLeadingPattern: let leadingLeft, indexForTrailingPattern: let trailingLeft, direction: .backward), .some(indexForLeadingPattern: let leadingRight, indexForTrailingPattern: let trailingRight, direction: .backward)):
			return (trailingLeft, leadingLeft) < (trailingRight, leadingRight)
			
			case (.some, .some):
			preconditionFailure("Conflicting directions")
			
			case (.some, .end):
			return true
			
			case (.end, .some):
			return false
			
			case (.end, .end):
			return false
			
		}
	}
	
	public static func ==<LeadingPattern, TrailingPattern>(leftIndex: ConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>, rightIndex: ConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>) -> Bool {
		switch (leftIndex, rightIndex) {
			
			case (.some(indexForLeadingPattern: let ilpl, indexForTrailingPattern: let itpl, direction: let dl), .some(indexForLeadingPattern: let ilpr, indexForTrailingPattern: let itpr,	direction: let dr)):
			return (ilpl, itpl, dl) == (ilpr, itpr, dr)
			
			case (.end, .end):
			return true
			
			default:
			return false
			
		}
	}
	
}



