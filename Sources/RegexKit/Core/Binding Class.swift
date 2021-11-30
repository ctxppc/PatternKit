// PatternKit © 2017–21 Constantino Tsarouhas

/// A categorisation that indicates how an expression's elements interact with elements in a superexpression.
///
/// An expression of a higher binding class binds its symbols tigher than an expression of a lower binding class. When a subexpression has a lower (or equal) binding class than the environment in its superexpression, the superexpression must wrap the subexpression's symbols with noncapturing grouping symbols.
public enum BindingClass : Int, Equatable {
	
	/// The binding class of alternations.
	///
	/// This is the lowest binding class.
	case alternation
	
	/// The binding class of concatenations.
	case concatenation
	
	/// The binding class of quantified expressions (the subexpression and associated quantifier).
	case quantified
	
	/// The binding class of atomic expressions, i.e., expressions whose symbols form a lexically indivisible unit.
	///
	/// This is the highest binding class.
	case atomic
	
}

extension BindingClass : Comparable {
	public static func <(lowerClass: Self, higherClass: Self) -> Bool {
		lowerClass.rawValue < higherClass.rawValue
	}
}
