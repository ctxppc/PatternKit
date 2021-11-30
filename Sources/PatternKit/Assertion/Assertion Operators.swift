// PatternKit © 2017–21 Constantino Tsarouhas

/// The forward-matching pattern assertion operator.
prefix operator ?=

/// Returns a forward assertion.
///
/// - Parameter assertedPattern: The asserted pattern.
///
/// - Returns: A forward-matching assertion.
public prefix func ?=<P>(assertedPattern: P) -> ForwardAssertion<P> {
	.init(assertedPattern)
}

/// The negated forward-matching pattern assertion operator.
prefix operator ?!

/// Returns a negated forward-matching assertion.
///
/// - Parameter assertedPattern: The asserted pattern.
///
/// - Returns: A negated forward-matching assertion.
public prefix func ?!<P>(assertedPattern: P) -> NegatedForwardAssertion<P> {
	.init(assertedPattern)
}

/// The backward-matching pattern assertion operator.
prefix operator ?<=

/// Returns a backward-matching assertion.
///
/// - Parameter assertedPattern: The asserted pattern.
///
/// - Returns: A backward-matching assertion.
public prefix func ?<=<P>(assertedPattern: P) -> BackwardAssertion<P> {
	.init(assertedPattern)
}

/// The negated backward-matching pattern assertion operator.
prefix operator ?<!

/// Returns a negated backward-matching assertion.
///
/// - Parameter assertedPattern: The asserted pattern.
///
/// - Returns: A negated backward-matching assertion.
public prefix func ?<!<P>(assertedPattern: P) -> NegatedBackwardAssertion<P> {
	.init(assertedPattern)
}
