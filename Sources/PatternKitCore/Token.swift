// PatternKit © 2017–21 Constantino Tsarouhas

public final class Token<CapturedPattern : Pattern> {
	
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
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> LazyMapCollection<CapturedPattern.ForwardMatchCollection, Match<Subject>> {
		capturedPattern
			.forwardMatches(enteringFrom: base)
			.lazy
			.map { match in match.capturing(base.inputPosition..<match.inputPosition, for: self) }
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> LazyMapCollection<CapturedPattern.BackwardMatchCollection, Match<Subject>> {
		capturedPattern
			.backwardMatches(recedingFrom: base)
			.lazy
			.map { $0.capturing($0.inputPosition..<base.inputPosition, for: self) }
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		capturedPattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		capturedPattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition)
	}
	
}

extension Token : BidirectionalCollection {
	
	public enum Index : Int, Hashable {
		
		/// The position of the captured pattern.
		case capturedPattern = 0
		
		/// The past-the-end position.
		case end
		
	}
	
	public var startIndex: Index { .capturedPattern }
	
	public var endIndex: Index { .end }
	
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
	public static func <(leftIndex: Self, rightIndex: Self) -> Bool {
		leftIndex.rawValue < rightIndex.rawValue
	}
}
