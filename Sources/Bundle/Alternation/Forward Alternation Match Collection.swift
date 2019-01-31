// PatternKit © 2017–19 Constantino Tsarouhas

import PatternKitCore

/// A collection of matches of a concatenation pattern.
public struct ForwardAlternationMatchCollection<MainPattern : Pattern, AlternativePattern : Pattern> where MainPattern.Subject == AlternativePattern.Subject {
	
	public typealias Subject = MainPattern.Subject
	
	/// Creates a concatenation match pattern.
	///
	/// - Parameter mainPattern: The matches that are generated first.
	/// - Parameter alternativePattern: The matches that are generated after all matches of the main pattern have been generated.
	/// - Parameter baseMatch: The base match.
	internal init(mainPattern: MainPattern, alternativePattern: AlternativePattern, baseMatch: Match<Subject>) {
		self.matchesOfMainPattern = mainPattern.forwardMatches(enteringFrom: baseMatch)
		self.matchesOfAlternativePattern = alternativePattern.forwardMatches(enteringFrom: baseMatch)
		self.baseMatch = baseMatch
	}
	
	/// The matches that are generated first.
	public let matchesOfMainPattern: MainPattern.ForwardMatchCollection
	
	/// The matches that are generated after all matches of the main pattern have been generated.
	public let matchesOfAlternativePattern: AlternativePattern.ForwardMatchCollection
	
	/// The base match.
	public let baseMatch: Match<Subject>
	
}

extension ForwardAlternationMatchCollection : BidirectionalCollection {
	
	public typealias Index = ForwardAlternationMatchCollectionIndex<MainPattern, AlternativePattern>
	
	public var startIndex: Index {
		if matchesOfMainPattern.startIndex != matchesOfMainPattern.endIndex {
			return .inMainPattern(innerIndex: matchesOfMainPattern.startIndex)
		} else if matchesOfAlternativePattern.startIndex != matchesOfAlternativePattern.endIndex {
			return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.startIndex)
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
			if matchesOfAlternativePattern.startIndex != matchesOfAlternativePattern.endIndex {
				return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.index(before: matchesOfAlternativePattern.endIndex))
			} else if matchesOfMainPattern.startIndex != matchesOfMainPattern.endIndex {
				return .inMainPattern(innerIndex: matchesOfMainPattern.index(before: matchesOfMainPattern.endIndex))
			} else {
				preconditionFailure("Index out of bounds")
			}
			
			case .inAlternativePattern(innerIndex: let innerIndex):
			if innerIndex != matchesOfAlternativePattern.startIndex {
				return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.index(before: innerIndex))
			} else {
				precondition(matchesOfMainPattern.endIndex != matchesOfMainPattern.startIndex, "Index out of bounds")
				return .inMainPattern(innerIndex: matchesOfMainPattern.index(before: matchesOfMainPattern.endIndex))
			}
			
			case .inMainPattern(innerIndex: let innerIndex):
			if innerIndex != matchesOfMainPattern.startIndex {
				return .inMainPattern(innerIndex: matchesOfMainPattern.index(before: innerIndex))
			} else {
				preconditionFailure("Index out of bounds")
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
				guard matchesOfAlternativePattern.startIndex != matchesOfAlternativePattern.endIndex else { return .end }
				return .inAlternativePattern(innerIndex: matchesOfAlternativePattern.startIndex)
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

public enum ForwardAlternationMatchCollectionIndex<MainPattern : Pattern, AlternativePattern : Pattern> : Equatable where MainPattern.Subject == AlternativePattern.Subject {
	
	/// A position within the main pattern.
	///
	/// - Invariant: `innerIndex` is not equal to `matchesOfMainPattern.endIndex` of the alternation match collection.
	///
	/// - Parameter innerIndex: The index within the main pattern's match collection.
	case inMainPattern(innerIndex: MainPattern.ForwardMatchCollection.Index)
	
	/// A position within the alternative pattern.
	///
	/// - Invariant: `innerIndex` is not equal to `matchesOfAlternativePattern.endIndex` of the alternation match collection.
	///
	/// - Parameter innerIndex: The index within the alternative pattern's match collection.
	case inAlternativePattern(innerIndex: AlternativePattern.ForwardMatchCollection.Index)
	
	/// The position after the last element of the match collection.
	case end
	
}

extension ForwardAlternationMatchCollectionIndex : Comparable {
	public static func < <MainPattern, AlternativePattern>(leftIndex: ForwardAlternationMatchCollectionIndex<MainPattern, AlternativePattern>, rightIndex: ForwardAlternationMatchCollectionIndex<MainPattern, AlternativePattern>) -> Bool {
		switch (leftIndex, rightIndex) {
			
			case (.inMainPattern(innerIndex: let innerIndexOfLeftIndex), .inMainPattern(innerIndex: let innerIndexOfRightIndex)):
			return innerIndexOfLeftIndex < innerIndexOfRightIndex
			
			case (.inMainPattern, .inAlternativePattern):
			return true
			
			case (.inMainPattern, .end):
			return true
			
			case (.inAlternativePattern, .inMainPattern):
			return false
			
			case (.inAlternativePattern(innerIndex: let innerIndexOfLeftIndex), .inAlternativePattern(innerIndex: let innerIndexOfRightIndex)):
			return innerIndexOfLeftIndex < innerIndexOfRightIndex
			
			case (.inAlternativePattern, .end):
			return true
			
			default:
			return false
			
		}
	}
}
