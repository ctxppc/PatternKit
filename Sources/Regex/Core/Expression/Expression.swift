// PatternKit © 2017–21 Constantino Tsarouhas

/// A regular expression; a sequence of symbols that expresses a pattern that matches over strings.
///
/// Whereas a pattern type is responsible for defining particular matching behaviour, an expression is responsible for having a specific syntax. Most types of expression can be serialised for most or all regular expression languages, but some may be specific for one or two languages. Since most languages differ mostly in how specific symbols are represented, `Expression` values are language-agnostic, and the language-specific serialisation of each symbol is left to the implementation of the symbol.
public protocol Expression : BidirectionalCollection where Element == SymbolProtocol {
	
	/// The binding class of the expression.
	var bindingClass: BindingClass { get }
	
}

extension Expression {
	
	/// Returns a serialisation of the expression in a given language.
	///
	/// - Throws: An error if the expression can't be serialised.
	///
	/// - Parameter language: The language in which to serialise the expression.
	func serialisation(language: Language) throws -> String {
		return try map {
			try $0.serialisation(language: language)
		}.joined()
	}
	
}
