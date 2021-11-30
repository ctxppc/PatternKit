// PatternKit © 2017–21 Constantino Tsarouhas

import DepthKit

/// A pattern that matches two patterns sequentially.
public struct Concatenation<LeadingPattern : Pattern, TrailingPattern : Pattern> where
	
	LeadingPattern.Subject == TrailingPattern.Subject,
	
	LeadingPattern.ForwardMatchCollection.Indices : OrderedCollection,
	TrailingPattern.ForwardMatchCollection.Indices : OrderedCollection,

	LeadingPattern.BackwardMatchCollection.Indices : OrderedCollection,
	TrailingPattern.BackwardMatchCollection.Indices : OrderedCollection {
	
	public typealias Subject = LeadingPattern.Subject
	
	/// Creates a concatenation.
	///
	/// - Parameter leadingPattern: The pattern that matches the first part of the concatenation.
	/// - Parameter trailingPattern: The pattern that matches the part after the part matched by the leading pattern.
	public init(_ leadingPattern: LeadingPattern, _ trailingPattern: TrailingPattern) {
		self.leadingPattern = leadingPattern
		self.trailingPattern = trailingPattern
	}
	
	/// The pattern that matches the first part of the concatenation.
	public var leadingPattern: LeadingPattern
	
	/// The pattern that matches the part after the part matched by the leading pattern.
	public var trailingPattern: TrailingPattern
	
}

extension Concatenation : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> ForwardConcatenationMatchCollection<LeadingPattern, TrailingPattern> {
		.init(leadingPattern: leadingPattern, trailingPattern: trailingPattern, baseMatch: base)
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> BackwardConcatenationMatchCollection<LeadingPattern, TrailingPattern> {
		.init(leadingPattern: leadingPattern, trailingPattern: trailingPattern, baseMatch: base)
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		leadingPattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		trailingPattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition)
	}
	
}

extension Concatenation : BidirectionalCollection {
	
	public enum Index : Int, Hashable {
		
		/// The position of the leading pattern.
		case leadingPattern = 0
		
		/// The position of the trailing pattern.
		case trailingPattern
		
		/// The past-the-end position.
		case end
		
	}
	
	public enum Element {
		
		/// The leading pattern.
		case leadingPattern(LeadingPattern)
		
		/// The trailing pattern.
		case trailingPattern(TrailingPattern)
		
	}
	
	public var startIndex: Index { .leadingPattern }
	
	public var endIndex: Index { .end }
	
	public subscript (index: Index) -> Element {
		switch index {
			case .leadingPattern:	return .leadingPattern(leadingPattern)
			case .trailingPattern:	return .trailingPattern(trailingPattern)
			case .end:				preconditionFailure("Index out of bounds")
		}
	}
	
	public func index(before index: Index) -> Index {
		switch index {
			case .leadingPattern:	preconditionFailure("Index out of bounds")
			case .trailingPattern:	return .leadingPattern
			case .end:				return .trailingPattern
		}
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			case .leadingPattern:	return .trailingPattern
			case .trailingPattern:	return .end
			case .end:				preconditionFailure("Index out of bounds")
		}
	}
	
}

extension Concatenation.Index : Comparable {
	public static func <(leftIndex: Self, rightIndex: Self) -> Bool {
		leftIndex.rawValue < rightIndex.rawValue
	}
}
