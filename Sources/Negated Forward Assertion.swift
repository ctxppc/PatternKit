// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that asserts that an asserted pattern does *not* match the part of the subject following the input position; also known as a negative lookahead.
///
/// For example, `NegatedForwardAssertion(Repeating(1...9, min: 5)) • Literal([1, 2, 3]) • any()+` matches all arrays starting with the elements 1, 2, and 3 that do not start with 5 elements between 1 and 9.
///
/// A negated assertion does not change the input position nor does it preserve any captures from tokens within the asserted pattern. Tokens within the asserted pattern essentially do not affect matching outside of the assertion, but can be used for reference patterns also contained within the assertion.
public struct NegatedForwardAssertion<AssertedPattern : Pattern> {
	
	public typealias Subject = AssertedPattern.Subject
	
	/// Creates a negated forward assertion.
	///
	/// - Parameter assertedPattern: The pattern that must produce at least one match for the assertion to hold.
	public init(_ assertedPattern: AssertedPattern) {
		self.assertedPattern = assertedPattern
	}
	
	/// The pattern that must not produce a match for the negated assertion to hold.
	public var assertedPattern: AssertedPattern
	
}

extension NegatedForwardAssertion : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<AssertedPattern.Subject>) -> NegatedForwardAssertionMatchCollection<AssertedPattern> {
		return NegatedForwardAssertionMatchCollection(assertedPattern: assertedPattern, baseMatch: base)
	}
	
	public func backwardMatches(recedingFrom base: Match<AssertedPattern.Subject>) -> NegatedForwardAssertionMatchCollection<AssertedPattern> {
		return NegatedForwardAssertionMatchCollection(assertedPattern: assertedPattern, baseMatch: base)
	}
	
}

extension NegatedForwardAssertion : BidirectionalCollection {
	
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

extension NegatedForwardAssertion.Index : Comparable {
	
	public static func <<P>(leftIndex: NegatedForwardAssertion<P>.Index, rightIndex: NegatedForwardAssertion<P>.Index) -> Bool {
		return leftIndex.rawValue < rightIndex.rawValue
	}
	
}
