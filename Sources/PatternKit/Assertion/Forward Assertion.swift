// PatternKit © 2017–21 Constantino Tsarouhas

import PatternKitCore

/// A pattern that asserts that an asserted pattern matches the part of the subject following the input position, without actually moving the input position beyond the assertion; also known as a positive lookahead.
///
/// For example, `ForwardAssertion(Repeating(1...9, min: 5)) • Literal([1, 2, 3]) • any()+` matches all arrays starting with at least 5 elements between 1 and 9; and starting with the elements 1, 2, and 3.
///
/// While the assertion does not change the input position, it does preserve captures by tokens contained within the asserted pattern. However, the assertion only produces one match from the asserted pattern.
///
/// Note that a forward assertion can also be used within a backward matching context; this does not affect the matching direction of the asserted pattern since the assertion itself is strictly forward-matching.
public struct ForwardAssertion<AssertedPattern : Pattern> {
	
	public typealias Subject = AssertedPattern.Subject
	
	/// Creates a forward assertion.
	///
	/// - Parameter assertedPattern: The pattern that must produce at least one match for the assertion to hold.
	public init(_ assertedPattern: AssertedPattern) {
		self.assertedPattern = assertedPattern
	}
	
	/// The pattern that must produce at least one match for the assertion to hold.
	public var assertedPattern: AssertedPattern
	
}

extension ForwardAssertion : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> ForwardAssertionMatchCollection<AssertedPattern> {
		return ForwardAssertionMatchCollection(assertedPattern: assertedPattern, baseMatch: base)
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> ForwardAssertionMatchCollection<AssertedPattern> {
		return ForwardAssertionMatchCollection(assertedPattern: assertedPattern, baseMatch: base)
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return assertedPattern.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subject, fromIndex inputPosition: Subject.Index) -> Subject.Index {
		return assertedPattern.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition)
	}
	
}

extension ForwardAssertion : BidirectionalCollection {
	
	public enum Index : Int, Hashable {
		
		/// The position of the asserted pattern.
		case assertedPattern = 0
		
		/// The past-the-end position.
		case end
		
	}
	
	public var startIndex: Index {
		return .assertedPattern
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> AssertedPattern {
		precondition(index == .assertedPattern, "Index out of bounds")
		return assertedPattern
	}
	
	public func index(before index: Index) -> Index {
		precondition(index == .end, "Index out of bounds")
		return .assertedPattern
	}
	
	public func index(after index: Index) -> Index {
		precondition(index == .assertedPattern, "Index out of bounds")
		return .end
	}
	
}

extension ForwardAssertion.Index : Comparable {
	public static func < <P>(leftIndex: ForwardAssertion<P>.Index, rightIndex: ForwardAssertion<P>.Index) -> Bool {
		return leftIndex.rawValue < rightIndex.rawValue
	}
}
