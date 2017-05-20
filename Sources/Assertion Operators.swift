// PatternKit © 2017 Constantino Tsarouhas

/// The forward-matching pattern assertion operator.
prefix operator ?=

/// Returns a forward-matching assertion.
///
/// - Parameter assertedPattern: The asserted pattern.
///
/// - Returns: `Assertion(assertedPattern, direction: .forward)`
public prefix func ?=<P>(assertedPattern: P) -> Assertion<P> {
	return Assertion(assertedPattern, direction: .forward)
}

/// The negated forward-matching pattern assertion operator.
prefix operator ?!

/// Returns a negated forward-matching assertion.
///
/// - Parameter assertedPattern: The asserted pattern.
///
/// - Returns: `NegatedAssertion(assertedPattern, direction: .forward)`
public prefix func ?!<P>(assertedPattern: P) -> NegatedAssertion<P> {
	return NegatedAssertion(assertedPattern, direction: .forward)
}

/// The backward-matching pattern assertion operator.
prefix operator ?<=

/// Returns a backward-matching assertion.
///
/// - Parameter assertedPattern: The asserted pattern.
///
/// - Returns: `Assertion(assertedPattern, direction: .backward)`
public prefix func ?<=<P>(assertedPattern: P) -> Assertion<P> {
	return Assertion(assertedPattern, direction: .backward)
}

/// The negated backward-matching pattern assertion operator.
prefix operator ?<!

/// Returns a negated backward-matching assertion.
///
/// - Parameter assertedPattern: The asserted pattern.
///
/// - Returns: `NegatedAssertion(assertedPattern, direction: .backward)`
public prefix func ?<!<P>(assertedPattern: P) -> NegatedAssertion<P> {
	return NegatedAssertion(assertedPattern, direction: .backward)
}
