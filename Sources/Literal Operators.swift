// PatternKit © 2017 Constantino Tsarouhas

/// The "literal" operator, for interjecting collections as literals within patterns.
prefix operator §

/// Forms a literal matching a collection.
///
/// This operator (or the initialiser it represents) is required unless the collection is quantified, e.g., `collection/?` or `collection+`. Note that a prefix and postfix operator cannot be applied simultaneously, i.e., `§collection+` is prohibited.
///
/// - Parameter collection: The collection to be matched exactly.
///
/// - Returns: `Literal(collection)`
public prefix func §<C>(collection: C) -> Literal<C> {
	return Literal(collection)
}

/// Forms a literal matching a string.
///
/// This operator (or the initialiser it represents) is required unless the string is quantified, e.g., `string/?` or `string+`. Note that a prefix and postfix operator cannot be applied simultaneously, i.e., `§string+` is prohibited.
///
/// - Parameter string: The string to be matched exactly.
///
/// - Returns: `Literal(string.characters)`
public prefix func §(string: String) -> Literal<String.CharacterView> {
	return Literal(string.characters)
}
