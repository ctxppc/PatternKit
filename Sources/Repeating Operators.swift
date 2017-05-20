// PatternKit © 2017 Constantino Tsarouhas

/// The unbounded Kleene operator with eager matching semantics.
postfix operator *

/// Returns an arbitrarily, eagerly repeating pattern over a given repeated pattern.
///
/// - Parameter repeatedPattern: The pattern that is repeated.
///
/// - Returns: `Repeating(repeatedPattern)`
public postfix func *<P>(repeatedPattern: P) -> Repeating<P> {
	return Repeating(repeatedPattern)
}

/// Returns an arbitrarily, eagerly repeating pattern over a given literal collection.
///
/// - Parameter repeatedlyMatchedCollection: The collection that is repeatedly matched exactly.
///
/// - Returns: `Repeating(Literal(repeatedlyMatchedCollection))`
public postfix func *<C>(repeatedlyMatchedCollection: C) -> Repeating<Literal<C>> {
	return Repeating(Literal(repeatedlyMatchedCollection))
}



/// The lower-bounded Kleene operator with eager matching semantics.
postfix operator +

/// Returns an arbitrarily, eagerly repeating pattern over a given repeated pattern that must match at least once.
///
/// - Parameter repeatedPattern: The pattern that is repeated.
///
/// - Returns: `Repeating(repeatedPattern, min: 1)`
public postfix func +<P>(repeatedPattern: P) -> Repeating<P> {
	return Repeating(repeatedPattern, min: 1)
}

/// Returns an arbitrarily, eagerly repeating pattern over a given literal collection that must match at least once.
///
/// - Parameter repeatedlyMatchedCollection: The collection that is repeatedly matched exactly.
///
/// - Returns: `Repeating(Literal(repeatedlyMatchedCollection), min: 1)`
public postfix func +<C>(repeatedlyMatchedCollection: C) -> Repeating<Literal<C>> {
	return Repeating(Literal(repeatedlyMatchedCollection), min: 1)
}



/// The unbounded Kleene operator with lazy matching semantics.
postfix operator *?

/// Returns an arbitrarily, lazily repeating pattern over a given repeated pattern.
///
/// - Parameter repeatedPattern: The pattern that is repeated.
///
/// - Returns: `Repeating(repeatedPattern, tendency: .lazy)`
public postfix func *?<P>(repeatedPattern: P) -> Repeating<P> {
	return Repeating(repeatedPattern, tendency: .lazy)
}

/// Returns an arbitrarily, lazily repeating pattern over a given literal collection.
///
/// - Parameter repeatedlyMatchedCollection: The collection that is repeatedly matched exactly.
///
/// - Returns: `Repeating(Literal(repeatedlyMatchedCollection), tendency: .lazy)`
public postfix func *?<C>(repeatedlyMatchedCollection: C) -> Repeating<Literal<C>> {
	return Repeating(Literal(repeatedlyMatchedCollection), tendency: .lazy)
}



/// The lower-bounded Kleene operator with lazy matching semantics.
postfix operator +?

/// Returns an arbitrarily, lazily repeating pattern over a given repeated pattern that must match at least once.
///
/// - Parameter repeatedPattern: The pattern that is repeated.
///
/// - Returns: `Repeating(repeatedPattern, min: 1, tendency: .lazy)`
public postfix func +?<P>(repeatedPattern: P) -> Repeating<P> {
	return Repeating(repeatedPattern, min: 1, tendency: .lazy)
}

/// Returns an arbitrarily, lazily repeating pattern over a given literal collection that must match at least once.
///
/// - Parameter repeatedlyMatchedCollection: The collection that is repeatedly matched exactly.
///
/// - Returns: `Repeating(Literal(repeatedlyMatchedCollection), min: 1, tendency: .lazy)`
public postfix func +?<C>(repeatedlyMatchedCollection: C) -> Repeating<Literal<C>> {
	return Repeating(Literal(repeatedlyMatchedCollection), min: 1, tendency: .lazy)
}



/// The optionality operator with eager matching semantics.
postfix operator /?

/// Returns a pattern that eagerly matches a given optional pattern.
///
/// - Parameter optionalPattern: The pattern that is eagerly but optionally matched.
///
/// - Returns: `Repeating(optionalPattern, max: 1)`
public postfix func /?<P>(optionalPattern: P) -> Repeating<P> {
	return Repeating(optionalPattern, max: 1)
}

/// Returns a pattern that eagerly matches a given optional pattern.
///
/// - Parameter optionalCollection: The collection that is eagerly but optionally matched.
///
/// - Returns: `Repeating(Literal(optionalCollection), max: 1)`
public postfix func /?<C>(optionalCollection: C) -> Repeating<Literal<C>> {
	return Repeating(Literal(optionalCollection), max: 1)
}



/// The optionality operator with lazy matching semantics.
postfix operator /??

/// Returns a pattern that lazily matches a given optional pattern.
///
/// - Parameter optionalPattern: The pattern that is lazily matched.
///
/// - Returns: `Repeating(optionalPattern, max: 1, tendency: .lazy)`
public postfix func /??<P>(optionalPattern: P) -> Repeating<P> {
	return Repeating(optionalPattern, max: 1, tendency: .lazy)
}

/// Returns a pattern that lazily matches a given optional pattern.
///
/// - Parameter optionalCollection: The collection that is lazily matched.
///
/// - Returns: `Repeating(Literal(optionalCollection), max: 1, tendency: .lazy)`
public postfix func /??<C>(optionalCollection: C) -> Repeating<Literal<C>> {
	return Repeating(Literal(optionalCollection), max: 1, tendency: .lazy)
}



/// Returns a pattern that produces at most once match from a given atomically-matched pattern.
///
/// - Parameter atomicallyMatchedPattern: The pattern that is atomically matched.
///
/// - Returns: `Repeating(atomicallyMatchedPattern, min: 1, max: 1, tendency: .possessive)`
public func atomic<P>(_ atomicallyMatchedPattern: P) -> Repeating<P> {
	return Repeating(atomicallyMatchedPattern, min: 1, max: 1, tendency: .possessive)
}
