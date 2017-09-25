// PatternKit © 2017 Constantino Tsarouhas

/// A regular expression that represents an alternation pattern.
public struct AlternationRegularExpression<MainExpression, AlternativeExpression> {
	
	/// Creates an alternation regular expression with given subexpressions.
	///
	/// - Parameter mainExpression: The expression that represents the main pattern of the alternation.
	/// - Parameter alternativeExpression: The expression that represents the alternative pattern of the alternation.
	public init(_ mainExpression: MainExpression, _ alternativeExpression: AlternativeExpression) {
		self.mainExpression = mainExpression
		self.alternativeExpression = alternativeExpression
	}
	
	/// The expression that represents the main pattern of the alternation.
	public var mainExpression: MainExpression
	
	/// The expression that represents the alternative pattern of the alternation.
	public var alternativeExpression: AlternativeExpression
	
}
