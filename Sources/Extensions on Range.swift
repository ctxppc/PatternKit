// PatternKit © 2017 Constantino Tsarouhas

extension Range {
	
	/// Returns a Boolean value indicating whether a range is fully contained within `self`.
	///
	/// - Parameter other: The other range.
	///
	/// - Returns: `true` if `other` is fully contained within `self`, `false` otherwise.
	public func contains(other: Range) -> Bool {
		return lowerBound <= other.lowerBound && upperBound >= other.upperBound
	}
	
}
