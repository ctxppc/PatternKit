// PatternKit © 2017–19 Constantino Tsarouhas

import DepthKit
import PatternKitCore

/// A collection of forward matches of a concatenation pattern.
public struct ForwardConcatenationMatchCollection<LeadingPattern : Pattern, TrailingPattern : Pattern> where
	LeadingPattern.Subject == TrailingPattern.Subject,
	LeadingPattern.ForwardMatchCollection.Indices : OrderedCollection,
	TrailingPattern.ForwardMatchCollection.Indices : OrderedCollection {
	
	public typealias Subject = LeadingPattern.Subject
	
	/// Creates a concatenation match collection.
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
	
	// TODO: Potentially optimise by caching match collection of the leading pattern
	
}

extension ForwardConcatenationMatchCollection : BidirectionalCollection {
	
	public typealias Index = ForwardConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>
	
	public var startIndex: Index {
		
		let matchesOfLeadingPattern = leadingPattern.forwardMatches(enteringFrom: baseMatch) as LeadingPattern.ForwardMatchCollection
		for (candidateIndexOfLeadingPattern, candidateMatchOfLeadingPattern) in zip(matchesOfLeadingPattern.indices, matchesOfLeadingPattern) {
			let matchesOfTrailingPattern = trailingPattern.forwardMatches(enteringFrom: candidateMatchOfLeadingPattern) as TrailingPattern.ForwardMatchCollection
			let candidateIndexOfTrailingPattern = matchesOfTrailingPattern.startIndex
			if candidateIndexOfTrailingPattern != matchesOfTrailingPattern.endIndex {
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
		
		let matchOfLeadingPattern = (leadingPattern.forwardMatches(enteringFrom: baseMatch) as LeadingPattern.ForwardMatchCollection)[indexForLeadingPattern]
		return (trailingPattern.forwardMatches(enteringFrom: matchOfLeadingPattern) as TrailingPattern.ForwardMatchCollection)[indexForTrailingPattern]
		
	}
	
	public func index(before index: Index) -> Index {
		
		let matchesOfLeadingPattern = leadingPattern.forwardMatches(enteringFrom: baseMatch) as LeadingPattern.ForwardMatchCollection
		let matchesOfTrailingPattern: TrailingPattern.ForwardMatchCollection
		let indexForLeadingPattern: LeadingPattern.ForwardMatchCollection.Index		// is never endIndex
		let indexForTrailingPattern: TrailingPattern.ForwardMatchCollection.Index	// may be endIndex
		
		switch index {
			
			case .some(indexForLeadingPattern: let ilp, indexForTrailingPattern: let itp):
			indexForLeadingPattern = ilp
			indexForTrailingPattern = itp
			matchesOfTrailingPattern = trailingPattern.forwardMatches(enteringFrom: matchesOfLeadingPattern[indexForLeadingPattern])
			
			case .end:
			precondition(matchesOfLeadingPattern.startIndex != matchesOfLeadingPattern.endIndex, "Index out of bounds")
			indexForLeadingPattern = matchesOfLeadingPattern.index(before: matchesOfLeadingPattern.endIndex)
			matchesOfTrailingPattern = trailingPattern.forwardMatches(enteringFrom: matchesOfLeadingPattern[indexForLeadingPattern])
			indexForTrailingPattern = matchesOfTrailingPattern.endIndex
			
		}
		
		if indexForTrailingPattern > matchesOfTrailingPattern.startIndex {
			return .some(indexForLeadingPattern: indexForLeadingPattern, indexForTrailingPattern: matchesOfTrailingPattern.index(before: indexForTrailingPattern))
		}
		
		for candidateIndexOfLeadingPattern in matchesOfLeadingPattern.indices.prefix(upTo: indexForLeadingPattern).reversed() {		// index range excludes indexForLeadingPattern, includes (and ends at) startIndex
			let matchesOfTrailingPattern = trailingPattern.forwardMatches(enteringFrom: matchesOfLeadingPattern[candidateIndexOfLeadingPattern]) as TrailingPattern.ForwardMatchCollection
			if matchesOfTrailingPattern.startIndex != matchesOfTrailingPattern.endIndex {
				return .some(indexForLeadingPattern: candidateIndexOfLeadingPattern, indexForTrailingPattern: matchesOfTrailingPattern.startIndex)
			}
		}
		
		preconditionFailure("Index out of bounds")
		
	}
	
	public func index(after index: Index) -> Index {
		
		guard case .some(indexForLeadingPattern: let indexForLeadingPattern, indexForTrailingPattern: let indexForTrailingPattern) = index else { preconditionFailure("Index out of bounds") }
		let matchesOfLeadingPattern = leadingPattern.forwardMatches(enteringFrom: baseMatch) as LeadingPattern.ForwardMatchCollection
		let matchesOfTrailingPattern = trailingPattern.forwardMatches(enteringFrom: matchesOfLeadingPattern[indexForLeadingPattern]) as TrailingPattern.ForwardMatchCollection
		
		let nextIndexOfTrailingPattern = matchesOfTrailingPattern.index(after: indexForTrailingPattern)
		if nextIndexOfTrailingPattern < matchesOfTrailingPattern.endIndex {
			return .some(indexForLeadingPattern: indexForLeadingPattern, indexForTrailingPattern: nextIndexOfTrailingPattern)
		}
		
		let nextIndexOfLeadingPattern = matchesOfLeadingPattern.index(after: indexForLeadingPattern)
		guard nextIndexOfLeadingPattern < matchesOfLeadingPattern.endIndex else { return .end }
		
		for nextIndexOfLeadingPattern in matchesOfLeadingPattern.indices[nextIndexOfLeadingPattern...] {	// index range includes nextIndexOfLeadingPattern, excludes endIndex
			let matchesOfTrailingPattern = trailingPattern.forwardMatches(enteringFrom: matchesOfLeadingPattern[nextIndexOfLeadingPattern]) as TrailingPattern.ForwardMatchCollection
			if matchesOfTrailingPattern.startIndex != matchesOfTrailingPattern.endIndex {
				return .some(indexForLeadingPattern: nextIndexOfLeadingPattern, indexForTrailingPattern: matchesOfTrailingPattern.startIndex)
			}
		}
		
		return .end
		
	}
	
}

public enum ForwardConcatenationMatchCollectionIndex<LeadingPattern : Pattern, TrailingPattern : Pattern> : Equatable where LeadingPattern.Subject == TrailingPattern.Subject {
	
	/// A position to a valid match.
	///
	/// - Invariant: `indexForLeadingPattern` is not equal to `endIndex` of the leading pattern's match collection, and `indexForTrailingPattern` is not equal to `endIndex` of the trailing pattern's match collection.
	///
	/// - Parameter indexForLeadingPattern: The index within the leading pattern's match collection.
	/// - Parameter indexForTrailingPattern: The index within the trailing pattern's match collection.
	case some(indexForLeadingPattern: LeadingPattern.ForwardMatchCollection.Index, indexForTrailingPattern: TrailingPattern.ForwardMatchCollection.Index)
	
	/// The position after the last element of the match collection.
	case end
	
}

extension ForwardConcatenationMatchCollectionIndex : Comparable {
	public static func < <LeadingPattern, TrailingPattern>(leftIndex: ForwardConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>, rightIndex: ForwardConcatenationMatchCollectionIndex<LeadingPattern, TrailingPattern>) -> Bool {
		switch (leftIndex, rightIndex) {
			
			case (.some(indexForLeadingPattern: let leadingLeft, indexForTrailingPattern: let trailingLeft), .some(indexForLeadingPattern: let leadingRight, indexForTrailingPattern: let trailingRight)):
			return (leadingLeft, trailingLeft) < (leadingRight, trailingRight)
			
			case (.some, .end):
			return true
			
			default:
			return false
			
		}
	}
}
