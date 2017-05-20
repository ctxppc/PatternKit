// PatternKit © 2017 Constantino Tsarouhas

/// The pattern concatenation operator.
infix operator • : AdditionPrecedence

/// Returns a concatenation of two arbitrary patterns.
///
/// - Parameter leadingPattern: The pattern that matches the first part of the concatenation.
/// - Parameter trailingPattern: The pattern that matches the part after the part matched by the leading pattern.
///
/// - Returns: `Concatenation(leadingPattern, trailingPattern)`
public func •<L, R>(leadingPattern: L, trailingPattern: R) -> Concatenation<L, R> {
	return Concatenation(leadingPattern, trailingPattern)
}

/// Returns a concatenation of two literal patterns.
///
/// This operator optimises the concatenation by merging the adjacent literals instead of creating a new concatenation construct over both literals.
///
/// - Parameter leadingLiteral: The literal pattern that matches the first part of the concatenation.
/// - Parameter trailingPattern: The literal pattern that matches the part after the part matched by the leading literal.
///
/// - Returns: A literal formed by concatenating `leadingLiteral` and `trailingLiteral`.
public func •<C : RangeReplaceableCollection>(leadingLiteral: Literal<C>, trailingLiteral: Literal<C>) -> Literal<C> {
	return Literal(leadingLiteral.literal.appending(contentsOf: trailingLiteral.literal))
}

/// Returns a concatenation of a literal pattern with a concatenation with a leading literal pattern.
///
/// This operator optimises the resulting concatenation by merging the adjacent literals.
///
/// - Parameter leadingLiteral: The literal pattern that matches the first part of the encompassing concatenation.
/// - Parameter trailingConcatenation: The concatenation pattern that matches the part after the part matched by the leading literal.
///
/// - Returns: A concatenation formed by prepending `leadingLiteral` to `trailingConcatenation`.
public func •<C : RangeReplaceableCollection, P>(leadingLiteral: Literal<C>, trailingConcatenation: Concatenation<Literal<C>, P>) -> Concatenation<Literal<C>, P> {
	let newLiteral = leadingLiteral.literal.appending(contentsOf: trailingConcatenation.leadingPattern.literal)
	return Concatenation(Literal(newLiteral), trailingConcatenation.trailingPattern)
}

/// Returns a concatenation of a concatenation (with a trailing literal pattern) with another literal pattern.
///
/// This operator optimises the resulting concatenation by merging the adjacent literals.
///
/// - Parameter leadingConcatenation: The concatenation pattern that matches the first part of the encompassing concatenation.
/// - Parameter trailingPattern: The literal pattern that matches the part after the part matched by the leading concatenation pattern.
///
/// - Returns: A concatenation formed by appending `trailingLiteral` to `leadingConcatenation`.
public func •<C : RangeReplaceableCollection, P>(leadingConcatenation: Concatenation<P, Literal<C>>, trailingLiteral: Literal<C>) -> Concatenation<P, Literal<C>> {
	let newLiteral = leadingConcatenation.trailingPattern.literal.appending(contentsOf: trailingLiteral.literal)
	return Concatenation(leadingConcatenation.leadingPattern, Literal(newLiteral))
}
