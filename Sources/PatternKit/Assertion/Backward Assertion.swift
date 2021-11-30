// PatternKit © 2017–21 Constantino Tsarouhas

/// A pattern that asserts that an asserted pattern matches the part of the subject preceding the input position, without actually moving the input position beyond the assertion; also known as a positive lookbehind.
///
/// While the assertion does not change the input position, it does preserve captures by tokens contained within the asserted pattern. However, the assertion only produces one match from the asserted pattern.
///
/// Note that a backward assertion can also be used within a forward matching context; this does not affect the matching direction of the asserted pattern since the assertion itself is strictly backward-matching.
public struct BackwardAssertion<AssertedPattern : Pattern> {
	
	public typealias Subject = AssertedPattern.Subject
	
	/// Creates a backward assertion.
	///
	/// - Parameter assertedPattern: The pattern that must produce at least one match for the assertion to hold.
	public init(_ assertedPattern: AssertedPattern) {
		self.assertedPattern = assertedPattern
	}
	
	/// The pattern that must produce at least one match for the assertion to hold.
	public var assertedPattern: AssertedPattern
	
}

extension BackwardAssertion : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> BackwardAssertionMatchCollection<AssertedPattern> {
		.init(assertedPattern: assertedPattern, baseMatch: base)
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> BackwardAssertionMatchCollection<AssertedPattern> {
		.init(assertedPattern: assertedPattern, baseMatch: base)
	}
	
}

extension BackwardAssertion : BidirectionalCollection {
	
	public enum Index : Int, Hashable {
		
		/// The position of the asserted pattern.
		case assertedPattern = 0
		
		/// The past-the-end position.
		case end
		
	}
	
	public var startIndex: Index { .assertedPattern }
	
	public var endIndex: Index { .end }
	
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

extension BackwardAssertion.Index : Comparable {
	public static func <(leftIndex: Self, rightIndex: Self) -> Bool {
		leftIndex.rawValue < rightIndex.rawValue
	}
}
