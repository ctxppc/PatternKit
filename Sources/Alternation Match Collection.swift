// PatternKit © 2017 Constantino Tsarouhas

/// A collection of matches of a concatenation pattern.
public struct AlternationMatchCollection<MainPattern : Pattern, AlternativePattern : Pattern> where
	MainPattern.Subject == AlternativePattern.Subject,
	MainPattern.MatchCollection.Iterator.Element == Match<MainPattern.Subject>,
	AlternativePattern.MatchCollection.Iterator.Element == Match<AlternativePattern.Subject> {	// TODO: Update constraints when better Collection constraints land, in Swift 4
	
	public typealias Subject = MainPattern.Subject
	
	/// Creates a concatenation match pattern.
	///
	/// - Parameter mainPattern: The matches that are generated first.
	/// - Parameter alternativePattern: The matches that are generated after all matches of the main pattern have been generated.
	/// - Parameter baseMatch: The base match.
	/// - Parameter direction: The direction of matching.
	internal init(mainPattern: MainPattern, alternativePattern: AlternativePattern, baseMatch: Match<Subject>, direction: MatchingDirection) {
		self.matchesOfMainPattern = mainPattern.matches(base: baseMatch, direction: direction)
		self.matchesOfAlternativePattern = alternativePattern.matches(base: baseMatch, direction: direction)
		self.baseMatch = baseMatch
		self.direction = direction
	}
	
	/// The matches that are generated first.
	public let matchesOfMainPattern: MainPattern.MatchCollection
	
	/// The matches that are generated after all matches of the main pattern have been generated.
	public let matchesOfAlternativePattern: AlternativePattern.MatchCollection
	
	/// The base match.
	public let baseMatch: Match<Subject>
	
	/// The direction of matching.
	public let direction: MatchingDirection
	
}

extension AlternationMatchCollection : BidirectionalCollection {
	
	public typealias Index = AlternationMatchCollectionIndex<MainPattern, AlternativePattern>
	
	public var startIndex: Index {
		switch direction {
			
			case .forward:
			if matchesOfMainPattern.startIndex != matchesOfMainPattern.endIndex {
				return .inMainPattern(innerIndex: matchesOfMainPattern.startIndex, direction: direction)
			} else if matchesOfAlternativePattern.startIndex != matchesOfAlternativePattern.endIndex {
				return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.startIndex, direction: direction)
			} else {
				return .end
			}
			
			case .backward:
			if matchesOfAlternativePattern.startIndex != matchesOfAlternativePattern.endIndex {
				return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.startIndex, direction: direction)
			} else if matchesOfMainPattern.startIndex != matchesOfMainPattern.endIndex {
				return .inMainPattern(innerIndex: matchesOfMainPattern.startIndex, direction: direction)
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
			case .inMainPattern(innerIndex: let innerIndex, direction: _):			return matchesOfMainPattern[innerIndex]
			case .inAlternativePattern(innerIndex: let innerIndex, direction: _):	return matchesOfAlternativePattern[innerIndex]
			case .end:																preconditionFailure("Index out of bounds")
		}
	}
	
	public func index(before index: Index) -> Index {
		switch index {
			
			case .end:
			switch direction {
				
				case .forward:
				if matchesOfAlternativePattern.startIndex != matchesOfAlternativePattern.endIndex {
					return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.index(before: matchesOfAlternativePattern.endIndex), direction: direction)
				} else if matchesOfMainPattern.startIndex != matchesOfMainPattern.endIndex {
					return .inMainPattern(innerIndex: matchesOfMainPattern.index(before: matchesOfMainPattern.endIndex), direction: direction)
				} else {
					preconditionFailure("Index out of bounds")
				}
				
				case .backward:
				if matchesOfMainPattern.startIndex != matchesOfMainPattern.endIndex {
					return .inMainPattern(innerIndex: matchesOfMainPattern.index(before: matchesOfMainPattern.endIndex), direction: direction)
				} else if matchesOfAlternativePattern.startIndex != matchesOfAlternativePattern.endIndex {
					return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.index(before: matchesOfAlternativePattern.endIndex), direction: direction)
				} else {
					preconditionFailure("Index out of bounds")
				}
				
			}
			
			case .inAlternativePattern(innerIndex: let innerIndex, direction: _):
			if innerIndex != matchesOfAlternativePattern.startIndex {
				return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.index(before: innerIndex), direction: direction)
			} else {
				precondition(direction == .forward, "Index out of bounds")
				precondition(matchesOfMainPattern.endIndex != matchesOfMainPattern.startIndex, "Index out of bounds")
				return .inMainPattern(innerIndex: matchesOfMainPattern.index(before: matchesOfMainPattern.endIndex), direction: direction)
			}
			
			case .inMainPattern(innerIndex: let innerIndex, direction: _):
			if innerIndex != matchesOfMainPattern.startIndex {
				return .inMainPattern(innerIndex: matchesOfMainPattern.index(before: innerIndex), direction: direction)
			} else {
				precondition(direction == .backward, "Index out of bounds")
				precondition(matchesOfAlternativePattern.endIndex != matchesOfAlternativePattern.startIndex, "Index out of bounds")
				return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.index(before: matchesOfAlternativePattern.endIndex), direction: direction)
			}
			
		}
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			
			case .inMainPattern(innerIndex: let innerIndex, direction: _):
			let nextInnerIndex = matchesOfMainPattern.index(after: innerIndex)
			if nextInnerIndex != matchesOfMainPattern.endIndex {
				return .inMainPattern(innerIndex: nextInnerIndex, direction: direction)
			} else {
				guard direction == .forward else { return .end }
				guard matchesOfAlternativePattern.startIndex != matchesOfAlternativePattern.endIndex else { return .end }
				return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.startIndex, direction: direction)
			}
			
			case .inAlternativePattern(innerIndex: let innerIndex, direction: _):
			let nextInnerIndex = matchesOfAlternativePattern.index(after: innerIndex)
			guard nextInnerIndex != matchesOfAlternativePattern.endIndex else { return .end }
			return .inAlternativePattern(innerIndex: nextInnerIndex, direction: direction)
			
			case .end:
			fatalError("Index out of bounds")
			
		}
	}
	
}

public enum AlternationMatchCollectionIndex<MainPattern : Pattern, AlternativePattern : Pattern> where MainPattern.Subject == AlternativePattern.Subject {
	
	/// A position within the main pattern.
	///
	/// - Invariant: `innerIndex` is not equal to `matchesOfMainPattern.endIndex` of the alternation match collection.
	///
	/// - Parameter innerIndex: The index within the main pattern's match collection.
	/// - Parameter direction: The direction in which the index is ordered.
	case inMainPattern(innerIndex: MainPattern.MatchCollection.Index, direction: MatchingDirection)
	
	/// A position within the alternative pattern.
	///
	/// - Invariant: `innerIndex` is not equal to `matchesOfAlternativePattern.endIndex` of the alternation match collection.
	///
	/// - Parameter innerIndex: The index within the alternative pattern's match collection.
	/// - Parameter direction: The direction in which the index is ordered.
	case inAlternativePattern(innerIndex: AlternativePattern.MatchCollection.Index, direction: MatchingDirection)
	
	/// The position after the last element of the match collection.
	case end
	
}

extension AlternationMatchCollectionIndex : Comparable {
	
	public static func <<MainPattern, AlternativePattern>(leftIndex: AlternationMatchCollectionIndex<MainPattern, AlternativePattern>, rightIndex: AlternationMatchCollectionIndex<MainPattern, AlternativePattern>) -> Bool {
		switch (leftIndex, rightIndex) {
			
			case (.inMainPattern(innerIndex: let innerIndexOfLeftIndex, direction: let direction), .inMainPattern(innerIndex: let innerIndexOfRightIndex, direction: let otherDirection)):
			precondition(direction == otherDirection, "Conflicting directions")
			return innerIndexOfLeftIndex < innerIndexOfRightIndex
			
			case (.inMainPattern(innerIndex: _, direction: let direction), .inAlternativePattern(innerIndex: _, direction: let otherDirection)):
			precondition(direction == otherDirection, "Conflicting directions")
			return direction == .forward
			
			case (.inMainPattern, .end):
			return true
			
			case (.inAlternativePattern(innerIndex: _, direction: let direction), .inMainPattern(innerIndex: _, direction: let otherDirection)):
			precondition(direction == otherDirection, "Conflicting directions")
			return direction == .backward
			
			case (.inAlternativePattern(innerIndex: let innerIndexOfLeftIndex, direction: let direction), .inAlternativePattern(innerIndex: let innerIndexOfRightIndex, direction: let otherDirection)):
			precondition(direction == otherDirection, "Conflicting directions")
			return innerIndexOfLeftIndex < innerIndexOfRightIndex
			
			case (.inAlternativePattern, .end):
			return true
			
			default:
			return false
			
		}
	}
	
	public static func ==<MainPattern, AlternativePattern>(firstIndex: AlternationMatchCollectionIndex<MainPattern, AlternativePattern>, secondIndex: AlternationMatchCollectionIndex<MainPattern, AlternativePattern>) -> Bool {
		switch (firstIndex, secondIndex) {
			
			case (.inMainPattern(let innerIndexOfLeftIndex, let directionOfLeftIndex), .inMainPattern(let innerIndexOfRightIndex, let directionOfRightIndex)):
			return (innerIndexOfLeftIndex, directionOfLeftIndex) == (innerIndexOfRightIndex, directionOfRightIndex)
			
			case (.inAlternativePattern(let innerIndexOfLeftIndex, let directionOfLeftIndex), .inAlternativePattern(let innerIndexOfRightIndex, let directionOfRightIndex)):
			return (innerIndexOfLeftIndex, directionOfLeftIndex) == (innerIndexOfRightIndex, directionOfRightIndex)
			
			case (.end, .end):
			return true
			
			default:
			return false
			
		}
	}
	
}



