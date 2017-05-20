// PatternKit © 2017 Constantino Tsarouhas

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

/// Returns an arbitrarily, lazily repeating pattern over a given literal string.
///
/// - Parameter repeatedlyMatchedCollection: The string that is repeatedly matched exactly.
///
/// - Returns: `Repeating(Literal(repeatedlyMatchedString.characters), tendency: .lazy)`
public postfix func *?(repeatedlyMatchedString: String) -> Repeating<Literal<String.CharacterView>> {
	return Repeating(Literal(repeatedlyMatchedString.characters), tendency: .lazy)
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

/// Returns an arbitrarily, lazily repeating pattern over a given literal string that must match at least once.
///
/// - Parameter repeatedlyMatchedCollection: The string that is repeatedly matched exactly.
///
/// - Returns: `Repeating(Literal(repeatedlyMatchedString.characters), min: 1, tendency: .lazy)`
public postfix func +?(repeatedlyMatchedString: String) -> Repeating<Literal<String.CharacterView>> {
	return Repeating(Literal(repeatedlyMatchedString.characters), min: 1, tendency: .lazy)
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

/// Returns a pattern that lazily matches a given optional collection.
///
/// - Parameter optionalCollection: The collection that is lazily matched.
///
/// - Returns: `Repeating(Literal(optionalCollection), max: 1, tendency: .lazy)`
public postfix func /??<C>(optionalCollection: C) -> Repeating<Literal<C>> {
	return Repeating(Literal(optionalCollection), max: 1, tendency: .lazy)
}

/// Returns a pattern that lazily matches a given optional string.
///
/// - Parameter optionalCollection: The string that is lazily matched.
///
/// - Returns: `Repeating(Literal(optionalString.characters), max: 1, tendency: .lazy)`
public postfix func /??(optionalString: String) -> Repeating<Literal<String.CharacterView>> {
	return Repeating(Literal(optionalString.characters), max: 1, tendency: .lazy)
}
