// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that asserts that an asserted pattern matches the part of the subject preceding the input position, without actually moving the input position beyond the assertion; also known as a positive lookbehind.
///
/// While the assertion does not change the input position, it does preserve captures by tokens contained within the asserted pattern. However, the assertion only produces one match from the asserted pattern.
///
/// Note that a backward assertion can also be used within a backward matching context. In that case, the backward assertion statically transforms (i.e., via the type system) into a forward assertion.
public struct BackwardAssertion<AssertedPattern : Pattern> where
	AssertedPattern.ForwardMatchCollection.Iterator.Element == Match<AssertedPattern.Subject>,
	AssertedPattern.BackwardMatchCollection.Iterator.Element == Match<AssertedPattern.Subject> {
	
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
		return BackwardAssertionMatchCollection(assertedPattern: assertedPattern, baseMatch: base)
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> ForwardAssertionMatchCollection<AssertedPattern> {
		return ForwardAssertionMatchCollection(assertedPattern: assertedPattern, baseMatch: base)
	}
	
}
