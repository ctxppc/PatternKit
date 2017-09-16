// PatternKit © 2017 Constantino Tsarouhas

import DepthKit

/// A collection of backward matches of a concatenation pattern.
public struct BackwardConcatenationMatchCollection<LeadingPattern : Pattern, TrailingPattern : Pattern> where
	LeadingPattern.Subject == TrailingPattern.Subject,
	LeadingPattern.BackwardMatchCollection.Indices : OrderedCollection,
	TrailingPattern.BackwardMatchCollection.Indices : OrderedCollection {
	
	public typealias Subject = LeadingPattern.Subject
	
	/// Creates a concatenation match pattern.
	///
	/// - Parameter leadingPattern: The matches of the first part of the concatenation.
	/// - Parameter trailingPattern: The matches of the part after the part matched by the leading pattern.
	/// - Parameter baseMatch: The base match.
	internal init(leadingPattern: LeadingPattern, trailingPattern: TrailingPattern, baseMatch: Match<Subject>) {
		self.leadingPattern = leadingPattern
		self.trailingPattern = trailingPattern
		self.baseMatch = baseMatch
	}
	
	/// The pattern matching the first part of the concatenation.
	public let leadingPattern: LeadingPattern
	
	/// The pattern matching the part after the part matched by the leading pattern.
	public let trailingPattern: TrailingPattern
	
	/// The base match.
	public let baseMatch: Match<Subject>
	
	// TODO: Potentially optimise by caching match collection of the trailing pattern
	
}

extension BackwardConcatenationMatchCollection : BidirectionalCollection {
	
	public typealias Index = BackwardConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>
	
	public var startIndex: Index {
			
		let matchesOfTrailingPattern = trailingPattern.backwardMatches(recedingFrom: baseMatch) as TrailingPattern.BackwardMatchCollection
		for (candidateIndexOfTrailingPattern, candidateMatchOfTrailingPattern) in zip(matchesOfTrailingPattern.indices, matchesOfTrailingPattern) {
			let matchesOfLeadingPattern = leadingPattern.backwardMatches(recedingFrom: candidateMatchOfTrailingPattern) as LeadingPattern.BackwardMatchCollection
			let candidateIndexOfLeadingPattern = matchesOfLeadingPattern.startIndex
			if candidateIndexOfLeadingPattern != matchesOfLeadingPattern.endIndex {
				return .some(indexForLeadingPattern: candidateIndexOfLeadingPattern, indexForTrailingPattern: candidateIndexOfTrailingPattern)
			}
		}
		
		return .end
		
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> Match<Subject> {
		
		guard case .some(indexForLeadingPattern: let indexForLeadingPattern, indexForTrailingPattern: let indexForTrailingPattern) = index else { preconditionFailure("Index out of bounds") }
		
		let matchOfTrailingPattern = (trailingPattern.backwardMatches(recedingFrom: baseMatch) as TrailingPattern.BackwardMatchCollection)[indexForTrailingPattern]
		return (leadingPattern.backwardMatches(recedingFrom: matchOfTrailingPattern) as LeadingPattern.BackwardMatchCollection)[indexForLeadingPattern]
		
	}
	
	public func index(before index: Index) -> Index {
		
		let matchesOfTrailingPattern = trailingPattern.backwardMatches(recedingFrom: baseMatch) as TrailingPattern.BackwardMatchCollection
		let matchesOfLeadingPattern: LeadingPattern.BackwardMatchCollection
		let indexForTrailingPattern: TrailingPattern.BackwardMatchCollection.Index	// is never endIndex
		let indexForLeadingPattern: LeadingPattern.BackwardMatchCollection.Index	// may be endIndex
		
		switch index {
			
			case .some(indexForLeadingPattern: let ilp, indexForTrailingPattern: let itp):
			indexForTrailingPattern = itp
			indexForLeadingPattern = ilp
			matchesOfLeadingPattern = leadingPattern.backwardMatches(recedingFrom: matchesOfTrailingPattern[indexForTrailingPattern])
			
			case .end:
			precondition(matchesOfTrailingPattern.startIndex != matchesOfTrailingPattern.endIndex, "Index out of bounds")
			indexForTrailingPattern = matchesOfTrailingPattern.index(before: matchesOfTrailingPattern.endIndex)
			matchesOfLeadingPattern = leadingPattern.backwardMatches(recedingFrom: matchesOfTrailingPattern[indexForTrailingPattern])
			indexForLeadingPattern = matchesOfLeadingPattern.endIndex
			
		}
		
		if indexForLeadingPattern > matchesOfLeadingPattern.startIndex {
			return .some(indexForLeadingPattern: matchesOfLeadingPattern.index(before: indexForLeadingPattern), indexForTrailingPattern: indexForTrailingPattern)
		}
		
		for candidateIndexOfTrailingPattern in matchesOfTrailingPattern.indices.prefix(upTo: indexForTrailingPattern).reversed() {	// index range excludes indexForLeadingPattern, includes (and ends at) startIndex
			let matchesOfLeadingPattern = leadingPattern.backwardMatches(recedingFrom: matchesOfTrailingPattern[candidateIndexOfTrailingPattern]) as LeadingPattern.BackwardMatchCollection
			if matchesOfLeadingPattern.startIndex != matchesOfLeadingPattern.endIndex {
				return .some(indexForLeadingPattern: matchesOfLeadingPattern.startIndex, indexForTrailingPattern: candidateIndexOfTrailingPattern)
			}
		}
		
		preconditionFailure("Index out of bounds")
		
	}
	
	public func index(after index: Index) -> Index {
		
		guard case .some(indexForLeadingPattern: let indexForLeadingPattern, indexForTrailingPattern: let indexForTrailingPattern) = index else { preconditionFailure("Index out of bounds") }
		let matchesOfTrailingPattern = trailingPattern.backwardMatches(recedingFrom: baseMatch) as TrailingPattern.BackwardMatchCollection
		let matchesOfLeadingPattern = leadingPattern.backwardMatches(recedingFrom: matchesOfTrailingPattern[indexForTrailingPattern]) as LeadingPattern.BackwardMatchCollection
		
		let nextIndexForLeadingPattern = matchesOfLeadingPattern.index(after: indexForLeadingPattern)
		if nextIndexForLeadingPattern < matchesOfLeadingPattern.endIndex {
			return .some(indexForLeadingPattern: nextIndexForLeadingPattern, indexForTrailingPattern: indexForTrailingPattern)
		}
		
		let nextIndexOfTrailingPattern = matchesOfTrailingPattern.index(after: indexForTrailingPattern)
		guard nextIndexOfTrailingPattern < matchesOfTrailingPattern.endIndex else { return .end }
		
		for nextIndexOfTrailingPattern in matchesOfTrailingPattern.indices.suffix(from: nextIndexOfTrailingPattern) {	// index range includes nextIndexOfTrailingPattern, excludes endIndex
			let matchesOfLeadingPattern = leadingPattern.backwardMatches(recedingFrom: matchesOfTrailingPattern[nextIndexOfTrailingPattern]) as LeadingPattern.BackwardMatchCollection
			if matchesOfLeadingPattern.startIndex != matchesOfLeadingPattern.endIndex {
				return .some(indexForLeadingPattern: matchesOfLeadingPattern.startIndex, indexForTrailingPattern: nextIndexOfTrailingPattern)
			}
		}
		
		return .end
		
	}
	
}

public enum BackwardConcatenationMatchCollectionIndex<LeadingPattern : Pattern, TrailingPattern : Pattern> where LeadingPattern.Subject == TrailingPattern.Subject {
	
	/// A position to a valid match.
	///
	/// - Invariant: `indexForLeadingPattern` is not equal to `endIndex` of the leading pattern's match collection, and `indexForTrailingPattern` is not equal to `endIndex` of the trailing pattern's match collection.
	///
	/// - Parameter indexForLeadingPattern: The index within the leading pattern's match collection.
	/// - Parameter indexForTrailingPattern: The index within the trailing pattern's match collection.
	case some(indexForLeadingPattern: LeadingPattern.BackwardMatchCollection.Index, indexForTrailingPattern: TrailingPattern.BackwardMatchCollection.Index)
	
	/// The position after the last element of the match collection.
	case end
	
}

extension BackwardConcatenationMatchCollectionIndex : Comparable {
	
	public static func <<LeadingPattern, TrailingPattern>(leftIndex: BackwardConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>, rightIndex: BackwardConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>) -> Bool {
		switch (leftIndex, rightIndex) {
			
			case (.some(indexForLeadingPattern: let leadingLeft, indexForTrailingPattern: let trailingLeft), .some(indexForLeadingPattern: let leadingRight, indexForTrailingPattern: let trailingRight)):
			return (trailingLeft, leadingLeft) < (trailingRight, leadingRight)
			
			case (.some, .end):
			return true
			
			default:
			return false
			
		}
	}
	
	public static func ==<LeadingPattern, TrailingPattern>(leftIndex: BackwardConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>, rightIndex: BackwardConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>) -> Bool {
		switch (leftIndex, rightIndex) {
			
			case (.some(indexForLeadingPattern: let ilpl, indexForTrailingPattern: let itpl), .some(indexForLeadingPattern: let ilpr, indexForTrailingPattern: let itpr)):
			return (ilpl, itpl) == (ilpr, itpr)
			
			case (.end, .end):
			return true
			
			default:
			return false
			
		}
	}
	
}
