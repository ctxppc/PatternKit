// PatternKit © 2017 Constantino Tsarouhas

/// A collection of matches of a concatenation pattern.
public struct ConcatenationMatchCollection<LeadingPattern : Pattern, TrailingPattern : Pattern> where
	LeadingPattern.Subject == TrailingPattern.Subject,
	LeadingPattern.MatchCollection.Iterator.Element == Match<LeadingPattern.Subject>,
	TrailingPattern.MatchCollection.Iterator.Element == Match<TrailingPattern.Subject> {
	
	public typealias Subject = LeadingPattern.Subject
	
	/// Creates a concatenation match pattern.
	///
	/// - Parameter leadingPattern: The matches of the first part of the concatenation.
	/// - Parameter trailingPattern: The matches of the part after the part matched by the leading pattern.
	/// - Parameter baseMatch: The base match.
	/// - Parameter direction: The direction of matching.
	internal init(leadingPattern: LeadingPattern, trailingPattern: TrailingPattern, baseMatch: Match<Subject>, direction: MatchingDirection) {
		self.matchesOfLeadingPattern = leadingPattern.matches(base: baseMatch, direction: direction)
		self.matchesOfTrailingPattern = trailingPattern.matches(base: baseMatch, direction: direction)
		self.baseMatch = baseMatch
		self.direction = direction
	}
	
	/// The matches of the first part of the concatenation.
	public let matchesOfLeadingPattern: LeadingPattern.MatchCollection
	
	/// The matches of the part after the part matched by the leading pattern.
	public let matchesOfTrailingPattern: TrailingPattern.MatchCollection
	
	/// The base match.
	public let baseMatch: Match<Subject>
	
	/// The direction of matching.
	public let direction: MatchingDirection
	
}

extension ConcatenationMatchCollection : BidirectionalCollection {
	
	public typealias Index = ConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>
	
	public var startIndex: Index {
		switch direction {
			
			case .forward:
			if matchesOfLeadingPattern.startIndex != matchesOfLeadingPattern.endIndex {
				return .inLeadingPattern(innerIndex: matchesOfLeadingPattern.startIndex, direction: direction)
			} else if matchesOfTrailingPattern.startIndex != matchesOfTrailingPattern.endIndex {
				return .inTrailingPattern(innerIndex: matchesOfTrailingPattern.startIndex, direction: direction)
			} else {
				return .end
			}
			
			case .backward:
			if matchesOfTrailingPattern.startIndex != matchesOfTrailingPattern.endIndex {
				return .inTrailingPattern(innerIndex: matchesOfTrailingPattern.startIndex, direction: direction)
			} else if matchesOfLeadingPattern.startIndex != matchesOfLeadingPattern.endIndex {
				return .inLeadingPattern(innerIndex: matchesOfLeadingPattern.startIndex, direction: direction)
			} else {
				return .end
			}
			
		}
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> Match<Subject> {
		switch index {
			case .inLeadingPattern(innerIndex: let innerIndex, direction: _):	return matchesOfLeadingPattern[innerIndex]
			case .inTrailingPattern(innerIndex: let innerIndex, direction: _):	return matchesOfTrailingPattern[innerIndex]
			case .end:															preconditionFailure("Index out of bounds")
		}
	}
	
	public func index(before index: Index) -> Index {
		switch index {
			
			case .end:
			switch direction {
				
				case .forward:
				if matchesOfTrailingPattern.startIndex != matchesOfTrailingPattern.endIndex {
					return .inTrailingPattern(innerIndex: matchesOfTrailingPattern.index(before: matchesOfTrailingPattern.endIndex), direction: direction)
				} else if matchesOfLeadingPattern.startIndex != matchesOfLeadingPattern.endIndex {
					return .inLeadingPattern(innerIndex: matchesOfLeadingPattern.index(before: matchesOfLeadingPattern.endIndex), direction: direction)
				} else {
					preconditionFailure("Index out of bounds")
				}
				
				case .backward:
				if matchesOfLeadingPattern.startIndex != matchesOfLeadingPattern.endIndex {
					return .inLeadingPattern(innerIndex: matchesOfLeadingPattern.index(before: matchesOfLeadingPattern.endIndex), direction: direction)
				} else if matchesOfTrailingPattern.startIndex != matchesOfTrailingPattern.endIndex {
					return .inTrailingPattern(innerIndex: matchesOfTrailingPattern.index(before: matchesOfTrailingPattern.endIndex), direction: direction)
				} else {
					preconditionFailure("Index out of bounds")
				}
				
			}
			
			case .inTrailingPattern(innerIndex: let innerIndex, direction: let otherDirection):
			precondition(direction == otherDirection, "Different directions")
			if innerIndex != matchesOfTrailingPattern.startIndex {
				return .inTrailingPattern(innerIndex: matchesOfTrailingPattern.index(before: innerIndex), direction: direction)
			} else {
				precondition(direction == .forward, "Index out of bounds")
				precondition(matchesOfLeadingPattern.endIndex != matchesOfLeadingPattern.startIndex, "Index out of bounds")
				return .inLeadingPattern(innerIndex: matchesOfLeadingPattern.index(before: matchesOfLeadingPattern.endIndex), direction: direction)
			}
			
			case .inLeadingPattern(innerIndex: let innerIndex, direction: let otherDirection):
			precondition(direction == otherDirection, "Different directions")
			if innerIndex != matchesOfLeadingPattern.startIndex {
				return .inLeadingPattern(innerIndex: matchesOfLeadingPattern.index(before: innerIndex), direction: direction)
			} else {
				precondition(direction == .backward, "Index out of bounds")
				precondition(matchesOfTrailingPattern.endIndex != matchesOfTrailingPattern.startIndex, "Index out of bounds")
				return .inTrailingPattern(innerIndex: matchesOfTrailingPattern.index(before: matchesOfTrailingPattern.endIndex), direction: direction)
			}
			
		}
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			
			case .inLeadingPattern(innerIndex: let innerIndex, direction: let otherDirection):
			precondition(direction == otherDirection, "Different directions")
			let nextInnerIndex = matchesOfLeadingPattern.index(after: innerIndex)
			if nextInnerIndex != matchesOfLeadingPattern.endIndex {
				return .inLeadingPattern(innerIndex: nextInnerIndex, direction: direction)
			} else {
				guard direction == .forward else { return .end }
				guard matchesOfTrailingPattern.startIndex != matchesOfTrailingPattern.endIndex else { return .end }
				return .inTrailingPattern(innerIndex: matchesOfTrailingPattern.startIndex, direction: direction)
			}
			
			case .inTrailingPattern(innerIndex: let innerIndex, direction: let otherDirection):
			precondition(direction == otherDirection, "Different directions")
			let nextInnerIndex = matchesOfTrailingPattern.index(after: innerIndex)
			guard nextInnerIndex != matchesOfTrailingPattern.endIndex else { return .end }
			return .inTrailingPattern(innerIndex: nextInnerIndex, direction: direction)
			
			case .end:
			fatalError("Index out of bounds")
			
		}
	}
	
}

public enum ConcatenationMatchCollectionIndex<LeadingPattern : Pattern, TrailingPattern : Pattern> where LeadingPattern.Subject == TrailingPattern.Subject {
	
	/// A position within the leading pattern.
	///
	/// - Invariant: `innerIndex` is not equal to `matchesOfLeadingPattern.endIndex` of the concatenation match collection.
	///
	/// - Parameter innerIndex: The index within the leading pattern.
	/// - Parameter direction: The direction in which the index is ordered.
	case inLeadingPattern(innerIndex: LeadingPattern.MatchCollection.Index, direction: MatchingDirection)
	
	/// A position within the trailing pattern.
	///
	/// - Invariant: `innerIndex` is not equal to `matchesOfLeadingPattern.endIndex` of the concatenation match collection.
	///
	/// - Parameter innerIndex: The index within the trailing pattern.
	/// - Parameter direction: The direction in which the index is ordered.
	case inTrailingPattern(innerIndex: TrailingPattern.MatchCollection.Index, direction: MatchingDirection)
	
	/// The position after the last element of the collection.
	case end
	
}

extension ConcatenationMatchCollectionIndex : Comparable {
	
	public static func <<LeadingPattern, TrailingPattern>(left: ConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>, right: ConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>) -> Bool {
		switch (left, right) {
			
			case (.inLeadingPattern(innerIndex: let innerIndexOfLeft, direction: let direction), .inLeadingPattern(innerIndex: let innerIndexOfRight, direction: let otherDirection)):
			precondition(direction == otherDirection, "Different directions")
			return innerIndexOfLeft < innerIndexOfRight
			
			case (.inLeadingPattern(innerIndex: _, direction: let direction), .inTrailingPattern(innerIndex: _, direction: let otherDirection)):
			precondition(direction == otherDirection, "Different directions")
			return direction == .forward
			
			case (.inLeadingPattern, .end):
			return true
			
			case (.inTrailingPattern(innerIndex: _, direction: let direction), .inLeadingPattern(innerIndex: _, direction: let otherDirection)):
			precondition(direction == otherDirection, "Different directions")
			return direction == .backward
			
			case (.inTrailingPattern(innerIndex: let innerIndexOfLeft, direction: let direction), .inTrailingPattern(innerIndex: let innerIndexOfRight, direction: let otherDirection)):
			precondition(direction == otherDirection, "Different directions")
			return innerIndexOfLeft < innerIndexOfRight
			
			case (.inTrailingPattern, .end):
			return true
			
			default:
			return false
			
		}
	}
	
	public static func ==<LeadingPattern, TrailingPattern>(l: ConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>, r: ConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>) -> Bool {
		switch (l, r) {
			
			case (.inLeadingPattern(let innerIndexOfLeft, let directionOfLeft), .inLeadingPattern(let innerIndexOfRight, let directionOfRight)):
			return (innerIndexOfLeft, directionOfLeft) == (innerIndexOfRight, directionOfRight)
			
			case (.inTrailingPattern(let innerIndexOfLeft, let directionOfLeft), .inTrailingPattern(let innerIndexOfRight, let directionOfRight)):
			return (innerIndexOfLeft, directionOfLeft) == (innerIndexOfRight, directionOfRight)
			
			case (.end, .end):
			return true
			
			default:
			return false
			
		}
	}
	
}



