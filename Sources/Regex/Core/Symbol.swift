// PatternKit © 2017 Constantino Tsarouhas

/// A indivisible sequence of characters that forms a lexical unit in a regular expression.
///
/// Note that a symbol value doesn't only carry a specific serialisation for a set of languages, but also a precise lexical meaning. It is, for example, incorrect to represent an alternation delimiter with a literal symbol serialising to `|`.
public protocol SymbolProtocol {
	
	// TODO
	
	/// Returns a serialisation of the symbol in a given language.
	///
	/// - Throws: An error if the symbol can't be serialised.
	///
	/// - Parameter language: The language in which to serialise the symbol.
	func serialisation(language: Language) throws -> String
	
}

/// A general error relating to serialising symbols.
public enum SymbolSerialisationError : Error {
	
	/// The symbol cannot be serialised in the given language.
	case unsupportedByLanguage
	
}
