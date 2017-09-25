// PatternKit © 2017 Constantino Tsarouhas

/// A regular expression that concatenates two or more subexpressions of the same type.
public struct HomogeneousConcatenatedRegularExpression<Subexpression> {
	
	/// Creates a homogeneous concatenated regular expression with given subexpressions.
	///
	/// - Parameter firstExpression: The first subexpression.
	/// - Parameter otherExpressions: The other subexpressions.
	public init(_ firstExpression: Subexpression, _ otherExpressions: Subexpression...) {
		self.subexpressions = [firstExpression] + otherExpressions
	}
	
	/// Creates a homogeneous concatenated regular expression with given subexpressions.
	///
	/// - Requires: `subexpressions` contains at least two subexpressions.
	///
	/// - Parameter subexpressions: The subexpressions.
	public init(_ subexpressions: [Subexpression]) {
		precondition(subexpressions.count >= 2, "Fewer than 2 subexpressions in concatenation")
		self.subexpressions = subexpressions
	}
	
	/// The concatenated subexpressions.
	///
	/// - Invariant: `subexpressions` contains at least two subexpressions.
	public var subexpressions: [Subexpression] {
		willSet {
			precondition(newValue.count >= 2, "Fewer than 2 subexpressions in concatenation")
		}
	}
	
}
