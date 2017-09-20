// PatternKit © 2017 Constantino Tsarouhas

public struct ConcatenatedRegularExpression<LeadingExpression, TrailingExpression> {
	
	/// Creates a concatenated regular expression.
	///
	/// - Parameter leadingExpression: The expression that forms the first part of the concatenated expression.
	/// - Parameter trailingExpression: The expression that follows the leading expression.
	public init(_ leadingExpression: LeadingExpression, _ trailingExpression: TrailingExpression) {
		self.leadingExpression = leadingExpression
		self.trailingExpression = trailingExpression
	}
	
	/// The expression that forms the first part of the concatenated expression.
	public var leadingExpression: LeadingExpression
	
	/// The expression that follows the leading expression.
	public var trailingExpression: TrailingExpression
	
}
