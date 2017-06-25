// PatternKit © 2017 Constantino Tsarouhas

public final class Token<CapturedPattern : Pattern> where
	CapturedPattern.ForwardMatchCollection.Iterator.Element == Match<CapturedPattern.Subject>,
	CapturedPattern.BackwardMatchCollection.Iterator.Element == Match<CapturedPattern.Subject> {
	
	public typealias Subject = CapturedPattern.Subject
	
	/// Creates a token capturing matches from a subpattern.
	///
	/// - Parameter subpattern: The subpattern.
	public init(_ subpattern: CapturedPattern) {
		self.capturedPattern = subpattern
	}
	
	/// The pattern whose matched subsequences are captured by the token.
	public var capturedPattern: CapturedPattern
	
}

extension Token : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> LazyMapBidirectionalCollection<CapturedPattern.ForwardMatchCollection, Match<Subject>> {
		return capturedPattern
			.forwardMatches(enteringFrom: base)
			.lazy
			.map { $0.capturing(base.inputPosition..<$0.inputPosition, for: self) }
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> LazyMapBidirectionalCollection<CapturedPattern.BackwardMatchCollection, Match<Subject>> {
		return capturedPattern
			.backwardMatches(recedingFrom: base)
			.lazy
			.map { $0.capturing($0.inputPosition..<base.inputPosition, for: self) }
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return capturedPattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return capturedPattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition)
	}
	
}

extension Token : BidirectionalCollection {
	
	public enum Index : Int, Hashable {
		
		/// The position of the captured pattern.
		case capturedPattern = 0
		
		/// The past-the-end position.
		case end
		
	}
	
	public var startIndex: Index {
		return .capturedPattern
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> CapturedPattern {
		precondition(index == .capturedPattern, "Index out of bounds")
		return capturedPattern
	}
	
	public func index(before index: Index) -> Index {
		precondition(index == .end, "Index out of bounds")
		return .capturedPattern
	}
	
	public func index(after index: Index) -> Index {
		precondition(index == .capturedPattern, "Index out of bounds")
		return .end
	}
	
}

extension Token.Index : Comparable {
	
	public static func <<P>(leftIndex: Token<P>.Index, rightIndex: Token<P>.Index) -> Bool {
		return leftIndex.rawValue < rightIndex.rawValue
	}
	
}
