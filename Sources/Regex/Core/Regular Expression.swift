// PatternKit © 2017 Constantino Tsarouhas

/// A sequence of symbols that expresses a pattern that matches over strings.
///
/// Whereas a pattern type is responsible for defining particular matching behaviour, a regular expression is responsible for having a specific syntax. Most types of regular expression can be serialised for most or all regular expression languages, but some may be specific for one or two languages. Since most languages differ mostly in how specific symbols are represented, `RegularExpression` values are language-agnostic, and the language-specific serialisation of each symbol is left to the implementation of the symbol.
public protocol RegularExpression : BidirectionalCollection where Element == SymbolProtocol {
	
	// TODO
	
}
