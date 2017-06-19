// PatternKit © 2017 Constantino Tsarouhas

/// The unbounded Kleene operator with eager matching semantics.
postfix operator *

/// Returns an arbitrarily, eagerly repeating pattern over a given repeated pattern.
///
/// - Parameter repeatedPattern: The pattern that is repeated.
///
/// - Returns: An arbitrarily, eagerly repeating pattern over `repeatedPattern`.
public postfix func *<P>(repeatedPattern: P) -> EagerlyRepeating<P> {
	return EagerlyRepeating(repeatedPattern)
}

/// Returns an arbitrarily, eagerly repeating pattern over a given literal collection.
///
/// - Parameter repeatedlyMatchedCollection: The collection that is repeatedly matched exactly.
///
/// - Returns: An arbitrarily, eagerly repeating pattern over a literal pattern matching `repeatedlyMatchedCollection`.
public postfix func *<C>(repeatedlyMatchedCollection: C) -> EagerlyRepeating<Literal<C>> {
	return EagerlyRepeating(Literal(repeatedlyMatchedCollection))
}

/// Returns an arbitrarily, eagerly repeating pattern over a given literal string.
///
/// - Parameter repeatedlyMatchedString: The string that is repeatedly matched exactly.
///
/// - Returns: An arbitrarily, eagerly repeating pattern over a literal pattern matching `repeatedlyMatchedString`.
public postfix func *(repeatedlyMatchedString: String) -> EagerlyRepeating<Literal<String.CharacterView>> {		// TODO: Remove in Swift 4
	return EagerlyRepeating(Literal(repeatedlyMatchedString.characters))
}



/// The lower-bounded Kleene operator with eager matching semantics.
postfix operator +

/// Returns an arbitrarily, eagerly repeating pattern over a given repeated pattern that must match at least once.
///
/// - Parameter repeatedPattern: The pattern that is repeated.
///
/// - Returns: An arbitrarily, nonoptional, eagerly repeating pattern over `repeatedPattern`.
public postfix func +<P>(repeatedPattern: P) -> EagerlyRepeating<P> {
	return EagerlyRepeating(repeatedPattern, min: 1)
}

/// Returns an arbitrarily, eagerly repeating pattern over a given literal collection that must match at least once.
///
/// - Parameter repeatedlyMatchedCollection: The collection that is repeatedly matched exactly.
///
/// - Returns: An arbitrarily, nonoptional, eagerly repeating pattern over a literal pattern matching `repeatedlyMatchedCollection`.
public postfix func +<C>(repeatedlyMatchedCollection: C) -> EagerlyRepeating<Literal<C>> {
	return EagerlyRepeating(Literal(repeatedlyMatchedCollection), min: 1)
}

/// Returns an arbitrarily, eagerly repeating pattern over a given literal string that must match at least once.
///
/// - Parameter repeatedlyMatchedString: The string that is repeatedly matched exactly.
///
/// - Returns: An arbitrarily, nonoptional, eagerly repeating pattern over a literal pattern matching `repeatedlyMatchedString`.
public postfix func +(repeatedlyMatchedString: String) -> EagerlyRepeating<Literal<String.CharacterView>> {		// TODO: Remove in Swift 4
	return EagerlyRepeating(Literal(repeatedlyMatchedString.characters), min: 1)
}



/// The optionality operator with eager matching semantics.
postfix operator /?

/// Returns a pattern that eagerly matches a given optional pattern.
///
/// - Parameter optionalPattern: The pattern that is eagerly but optionally matched.
///
/// - Returns: A pattern that optionally and eagerly matches `optionalPattern`.
public postfix func /?<P>(optionalPattern: P) -> EagerlyRepeating<P> {
	return EagerlyRepeating(optionalPattern, max: 1)
}

/// Returns a pattern that eagerly matches a given optional collection.
///
/// - Parameter optionalCollection: The collection that is eagerly but optionally matched.
///
/// - Returns: A pattern that optionally and eagerly matches the literal `optionalCollection`.
public postfix func /?<C>(optionalCollection: C) -> EagerlyRepeating<Literal<C>> {
	return EagerlyRepeating(Literal(optionalCollection), max: 1)
}

/// Returns a pattern that eagerly matches a given optional string.
///
/// - Parameter optionalString: The string that is eagerly but optionally matched.
///
/// - Returns: A pattern that optionally and eagerly matches the literal `optionalString`.
public postfix func /?(optionalString: String) -> EagerlyRepeating<Literal<String.CharacterView>> {				// TODO: Remove in Swift 4
	return EagerlyRepeating(Literal(optionalString.characters), max: 1)
}
