// PatternKit © 2017–19 Constantino Tsarouhas

/// The unbounded Kleene operator with lazy matching semantics.
postfix operator *?

/// Returns an arbitrarily, lazily repeating pattern over a given repeated pattern.
///
/// - Parameter repeatedPattern: The pattern that is repeated.
///
/// - Returns: An arbitrarily, lazily repeating pattern over `repeatedPattern`.
public postfix func *? <P>(repeatedPattern: P) -> LazilyRepeating<P> {
	return LazilyRepeating(repeatedPattern)
}

/// Returns an arbitrarily, lazily repeating pattern over a given literal collection.
///
/// - Parameter repeatedlyMatchedCollection: The collection that is repeatedly matched exactly.
///
/// - Returns: An arbitrarily, lazily repeating pattern over a literal pattern matching `repeatedlyMatchedCollection`.
public postfix func *? <C>(repeatedlyMatchedCollection: C) -> LazilyRepeating<Literal<C>> {
	return LazilyRepeating(Literal(repeatedlyMatchedCollection))
}



/// The lower-bounded Kleene operator with lazy matching semantics.
postfix operator +?

/// Returns an arbitrarily, lazily repeating pattern over a given repeated pattern that must match at least once.
///
/// - Parameter repeatedPattern: The pattern that is repeated.
///
/// - Returns: An arbitrarily, nonoptional, lazily repeating pattern over `repeatedPattern`.
public postfix func +? <P>(repeatedPattern: P) -> LazilyRepeating<P> {
	return LazilyRepeating(repeatedPattern, min: 1)
}

/// Returns an arbitrarily, lazily repeating pattern over a given literal collection that must match at least once.
///
/// - Parameter repeatedlyMatchedCollection: The collection that is repeatedly matched exactly.
///
/// - Returns: An arbitrarily, nonoptional, lazily repeating pattern over a literal pattern matching `repeatedlyMatchedCollection`.
public postfix func +? <C>(repeatedlyMatchedCollection: C) -> LazilyRepeating<Literal<C>> {
	return LazilyRepeating(Literal(repeatedlyMatchedCollection), min: 1)
}



/// The optionality operator with lazy matching semantics.
postfix operator /??

/// Returns a pattern that lazily matches a given optional pattern.
///
/// - Parameter optionalPattern: The pattern that is lazily matched.
///
/// - Returns: A pattern that optionally and lazily matches `optionalPattern`.
public postfix func /?? <P>(optionalPattern: P) -> LazilyRepeating<P> {
	return LazilyRepeating(optionalPattern, max: 1)
}

/// Returns a pattern that lazily matches a given optional collection.
///
/// - Parameter optionalCollection: The collection that is lazily matched.
///
/// - Returns: A pattern that optionally and lazily matches the literal `optionalCollection`.
public postfix func /?? <C>(optionalCollection: C) -> LazilyRepeating<Literal<C>> {
	return LazilyRepeating(Literal(optionalCollection), max: 1)
}
