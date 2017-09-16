// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that asserts that an asserted pattern does *not* match the part of the subject preceding the input position; also known as a negative lookbehind.
///
/// A negated assertion does not change the input position nor does it preserve any captures from tokens within the asserted pattern. Tokens within the asserted pattern essentially do not affect matching outside of the assertion, but can be used for reference patterns also contained within the assertion.
public struct NegatedBackwardAssertion<AssertedPattern : Pattern> {
	
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

extension NegatedBackwardAssertion : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<AssertedPattern.Subject>) -> NegatedBackwardAssertionMatchCollection<AssertedPattern> {
		return NegatedBackwardAssertionMatchCollection(assertedPattern: assertedPattern, baseMatch: base)
	}
	
	public func backwardMatches(recedingFrom base: Match<AssertedPattern.Subject>) -> NegatedBackwardAssertionMatchCollection<AssertedPattern> {
		return NegatedBackwardAssertionMatchCollection(assertedPattern: assertedPattern, baseMatch: base)
	}
	
}

extension NegatedBackwardAssertion : BidirectionalCollection {
	
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

extension NegatedBackwardAssertion.Index : Comparable {
	
	public static func <<P>(leftIndex: NegatedBackwardAssertion<P>.Index, rightIndex: NegatedBackwardAssertion<P>.Index) -> Bool {
		return leftIndex.rawValue < rightIndex.rawValue
	}
	
}
