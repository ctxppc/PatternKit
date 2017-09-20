// PatternKit © 2017 Constantino Tsarouhas

public protocol Symbol {
	
	// TODO
	
	/// Returns a serialisation of the symbol in a given language.
	///
	/// - Parameter language: The language in which to serialise the symbol.
	func serialisation(language: Language) -> String
	
}
