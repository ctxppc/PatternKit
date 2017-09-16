// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches any one element that is contained in a range.
public struct RangePattern<Subject : BidirectionalCollection> where
	Subject.Iterator.Element : Comparable,
	Subject.SubSequence : BidirectionalCollection,
	Subject.SubSequence.Iterator.Element == Subject.Iterator.Element {
	
	/// Creates a range pattern.
	///
	/// - Parameter range: The range of elements that are matched by the range pattern.
	public init(_ range: Swift.Range<Subject.Iterator.Element>) {
		self.range = .halfOpen(range)
	}
	
	/// Creates a range pattern.
	///
	/// - Parameter range: The range of elements that are matched by the range pattern.
	public init(_ range: ClosedRange<Subject.Iterator.Element>) {
		self.range = .closed(range)
	}
	
	/// The range of elements that are matched by the range pattern.
	public var range: Range
	public indirect enum Range {
		case halfOpen(Swift.Range<Subject.Iterator.Element>)
		case closed(ClosedRange<Subject.Iterator.Element>)
	}
	
}

extension RangePattern : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> SingularMatchCollection<Subject> {
		
		guard let element = base.remainingElements(direction: .forward).first else { return nil }
		
		switch range {
			case .halfOpen(let range):	guard range.contains(element) else { return nil }
			case .closed(let range):	guard range.contains(element) else { return nil }
		}
		
		return SingularMatchCollection(resultMatch: base.movingInputPosition(distance: 1, direction: .forward))
		
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> SingularMatchCollection<Subject> {
		
		guard let element = base.remainingElements(direction: .backward).last else { return nil }
		
		switch range {
		case .halfOpen(let range):	guard range.contains(element) else { return nil }
		case .closed(let range):	guard range.contains(element) else { return nil }
		}
		
		return SingularMatchCollection(resultMatch: base.movingInputPosition(distance: 1, direction: .backward))
		
	}
	
}
