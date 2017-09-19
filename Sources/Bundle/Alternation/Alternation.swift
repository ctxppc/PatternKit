// PatternKit © 2017 Constantino Tsarouhas

import PatternKitCore

/// A pattern that matches two patterns separately.
public struct Alternation<MainPattern : Pattern, AlternativePattern : Pattern> where MainPattern.Subject == AlternativePattern.Subject {
	
	public typealias Subject = MainPattern.Subject
	
	/// Creates a pattern that matches two patterns separately and sequentially.
	///
	/// - Parameter mainPattern: The pattern whose matches are generated first.
	/// - Parameter alternativePattern: The pattern whose matches are generated after those of the main pattern.
	public init(_ mainPattern: MainPattern, _ alternativePattern: AlternativePattern) {
		self.mainPattern = mainPattern
		self.alternativePattern = alternativePattern
	}
	
	/// The pattern whose matches are generated first.
	public var mainPattern: MainPattern
	
	/// The pattern whose matches are generated after those of the main pattern.
	public var alternativePattern: AlternativePattern
	
}

extension Alternation : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> ForwardAlternationMatchCollection<MainPattern, AlternativePattern> {
		return ForwardAlternationMatchCollection(mainPattern: mainPattern, alternativePattern: alternativePattern, baseMatch: base)
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> BackwardAlternationMatchCollection<MainPattern, AlternativePattern> {
		return BackwardAlternationMatchCollection(mainPattern: mainPattern, alternativePattern: alternativePattern, baseMatch: base)
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return Swift.min(mainPattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition), alternativePattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition))
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return Swift.max(mainPattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition), alternativePattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition))
	}
	
}

extension Alternation : BidirectionalCollection {
	
	public enum Index : Int, Hashable {
		
		/// The position of the main pattern.
		case mainPattern = 0
		
		/// The position of the alternative pattern.
		case alternativePattern
		
		/// The past-the-end position.
		case end
		
	}
	
	public enum Element {
		
		/// The main pattern.
		case mainPattern(MainPattern)
		
		/// The alternative pattern.
		case alternativePattern(AlternativePattern)
		
	}
	
	public var startIndex: Index {
		return .mainPattern
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> Element {
		switch index {
			case .mainPattern:			return .mainPattern(mainPattern)
			case .alternativePattern:	return .alternativePattern(alternativePattern)
			case .end:					preconditionFailure("Index out of bounds")
		}
	}
	
	public func index(before index: Index) -> Index {
		switch index {
			case .mainPattern:			preconditionFailure("Index out of bounds")
			case .alternativePattern:	return .mainPattern
			case .end:					return .alternativePattern
		}
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			case .mainPattern:			return .alternativePattern
			case .alternativePattern:	return .end
			case .end:					preconditionFailure("Index out of bounds")
		}
	}
	
}

extension Alternation.Index : Comparable {
	
	public static func <<M, A>(leftIndex: Alternation<M, A>.Index, rightIndex: Alternation<M, A>.Index) -> Bool {
		return leftIndex.rawValue < rightIndex.rawValue
	}
	
}
