// PatternKit © 2017–19 Constantino Tsarouhas

/// A grammar for serialising and deserialising expressions.
public enum Language : Hashable {
	
	/// The regular expression language in ECMAScript (ECMA-262 and ISO/IEC 16262).
	case ecmaScript
	
	/// The Perl Compatible Regular Expressions (PCRE) language.
	case perlCompatibleREs
	
}
