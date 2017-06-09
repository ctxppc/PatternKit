// PatternKit © 2017 Constantino Tsarouhas

/// A collection of matches of a concatenation pattern.
public struct BackwardAlternationMatchCollection<MainPattern : Pattern, AlternativePattern : Pattern> where
	MainPattern.Subject == AlternativePattern.Subject,
	MainPattern.BackwardMatchCollection.Iterator.Element == Match<MainPattern.Subject>,
	AlternativePattern.BackwardMatchCollection.Iterator.Element == Match<AlternativePattern.Subject> {	// TODO: Update constraints when better Collection constraints land, in Swift 4
	
	public typealias Subject = MainPattern.Subject
	
	/// Creates a concatenation match pattern.
	///
	/// - Parameter mainPattern: The matches that are generated first.
	/// - Parameter alternativePattern: The matches that are generated after all matches of the main pattern have been generated.
	/// - Parameter baseMatch: The base match.
	internal init(mainPattern: MainPattern, alternativePattern: AlternativePattern, baseMatch: Match<Subject>) {
		self.matchesOfMainPattern = mainPattern.backwardMatches(recedingFrom: baseMatch)
		self.matchesOfAlternativePattern = alternativePattern.backwardMatches(recedingFrom: baseMatch)
		self.baseMatch = baseMatch
	}
	
	/// The matches that are generated first.
	public let matchesOfMainPattern: MainPattern.BackwardMatchCollection
	
	/// The matches that are generated after all matches of the main pattern have been generated.
	public let matchesOfAlternativePattern: AlternativePattern.BackwardMatchCollection
	
	/// The base match.
	public let baseMatch: Match<Subject>
	
}

extension BackwardAlternationMatchCollection : BidirectionalCollection {
	
	public typealias Index = BackwardAlternationMatchCollectionIndex<MainPattern, AlternativePattern>
	
	public var startIndex: Index {
		if matchesOfAlternativePattern.startIndex != matchesOfAlternativePattern.endIndex {
			return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.startIndex)
		} else if matchesOfMainPattern.startIndex != matchesOfMainPattern.endIndex {
			return .inMainPattern(innerIndex: matchesOfMainPattern.startIndex)
		} else {
			return .end
		}
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> Match<Subject> {
		switch index {
			case .inMainPattern(innerIndex: let innerIndex):		return matchesOfMainPattern[innerIndex]
			case .inAlternativePattern(innerIndex: let innerIndex):	return matchesOfAlternativePattern[innerIndex]
			case .end:												preconditionFailure("Index out of bounds")
		}
	}
	
	public func index(before index: Index) -> Index {
		switch index {
			
			case .end:
			if matchesOfMainPattern.startIndex != matchesOfMainPattern.endIndex {
				return .inMainPattern(innerIndex: matchesOfMainPattern.index(before: matchesOfMainPattern.endIndex))
			} else if matchesOfAlternativePattern.startIndex != matchesOfAlternativePattern.endIndex {
				return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.index(before: matchesOfAlternativePattern.endIndex))
			} else {
				preconditionFailure("Index out of bounds")
			}
			
			case .inAlternativePattern(innerIndex: let innerIndex):
			if innerIndex != matchesOfAlternativePattern.startIndex {
				return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.index(before: innerIndex))
			} else {
				preconditionFailure("Index out of bounds")
			}
			
			case .inMainPattern(innerIndex: let innerIndex):
			if innerIndex != matchesOfMainPattern.startIndex {
				return .inMainPattern(innerIndex: matchesOfMainPattern.index(before: innerIndex))
			} else {
				precondition(matchesOfAlternativePattern.endIndex != matchesOfAlternativePattern.startIndex, "Index out of bounds")
				return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.index(before: matchesOfAlternativePattern.endIndex))
			}
			
		}
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			
			case .inMainPattern(innerIndex: let innerIndex):
			let nextInnerIndex = matchesOfMainPattern.index(after: innerIndex)
			if nextInnerIndex != matchesOfMainPattern.endIndex {
				return .inMainPattern(innerIndex: nextInnerIndex)
			} else {
				return .end
			}
			
			case .inAlternativePattern(innerIndex: let innerIndex):
			let nextInnerIndex = matchesOfAlternativePattern.index(after: innerIndex)
			guard nextInnerIndex != matchesOfAlternativePattern.endIndex else { return .end }
			return .inAlternativePattern(innerIndex: nextInnerIndex)
			
			case .end:
			preconditionFailure("Index out of bounds")
			
		}
	}
	
}

public enum BackwardAlternationMatchCollectionIndex<MainPattern : Pattern, AlternativePattern : Pattern> where MainPattern.Subject == AlternativePattern.Subject {
	
	/// A position within the main pattern.
	///
	/// - Invariant: `innerIndex` is not equal to `matchesOfMainPattern.endIndex` of the alternation match collection.
	///
	/// - Parameter innerIndex: The index within the main pattern's match collection.
	case inMainPattern(innerIndex: MainPattern.BackwardMatchCollection.Index)
	
	/// A position within the alternative pattern.
	///
	/// - Invariant: `innerIndex` is not equal to `matchesOfAlternativePattern.endIndex` of the alternation match collection.
	///
	/// - Parameter innerIndex: The index within the alternative pattern's match collection.
	case inAlternativePattern(innerIndex: AlternativePattern.BackwardMatchCollection.Index)
	
	/// The position after the last element of the match collection.
	case end
	
}

extension BackwardAlternationMatchCollectionIndex : Comparable {
	
	public static func <<MainPattern, AlternativePattern>(leftIndex: BackwardAlternationMatchCollectionIndex<MainPattern, AlternativePattern>, rightIndex: BackwardAlternationMatchCollectionIndex<MainPattern, AlternativePattern>) -> Bool {
		switch (leftIndex, rightIndex) {
			
			case (.inMainPattern(innerIndex: let innerIndexOfLeftIndex), .inMainPattern(innerIndex: let innerIndexOfRightIndex)):
			return innerIndexOfLeftIndex < innerIndexOfRightIndex
			
			case (.inMainPattern(innerIndex: _), .inAlternativePattern(innerIndex: _)):
			return false
			
			case (.inMainPattern, .end):
			return true
			
			case (.inAlternativePattern(innerIndex: _), .inMainPattern(innerIndex: _)):
			return true
			
			case (.inAlternativePattern(innerIndex: let innerIndexOfLeftIndex), .inAlternativePattern(innerIndex: let innerIndexOfRightIndex)):
			return innerIndexOfLeftIndex < innerIndexOfRightIndex
			
			case (.inAlternativePattern, .end):
			return true
			
			default:
			return false
			
		}
	}
	
	public static func ==<MainPattern, AlternativePattern>(firstIndex: BackwardAlternationMatchCollectionIndex<MainPattern, AlternativePattern>, secondIndex: BackwardAlternationMatchCollectionIndex<MainPattern, AlternativePattern>) -> Bool {
		switch (firstIndex, secondIndex) {
			
			case (.inMainPattern(innerIndex: let innerIndexOfLeftIndex), .inMainPattern(innerIndex: let innerIndexOfRightIndex)):
			return innerIndexOfLeftIndex == innerIndexOfRightIndex
			
			case (.inAlternativePattern(innerIndex: let innerIndexOfLeftIndex), .inAlternativePattern(innerIndex: let innerIndexOfRightIndex)):
			return innerIndexOfLeftIndex == innerIndexOfRightIndex
			
			case (.end, .end):
			return true
			
			default:
			return false
			
		}
	}
	
}



