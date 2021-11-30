// PatternKit © 2017–21 Constantino Tsarouhas

extension Range {
	
	/// Returns a Boolean value indicating whether a range is fully contained within `self`.
	///
	/// - Parameter other: The other range.
	///
	/// - Returns: `true` if `other` is fully contained within `self`, `false` otherwise.
	public func contains(_ other: Range) -> Bool {
		self.lowerBound <= other.lowerBound && self.upperBound >= other.upperBound
	}
	
	/// Returns a Boolean value indicating whether a range is fully contained within `self`.
	///
	/// - Parameter other: The other range.
	///
	/// - Returns: `true` if `other` is fully contained within `self`, `false` otherwise.
	public func contains(_ other: ClosedRange<Bound>) -> Bool {
		self.lowerBound <= other.lowerBound && self.upperBound > other.upperBound
	}
	
}

extension ClosedRange {
	
	/// Returns a Boolean value indicating whether a range is fully contained within `self`.
	///
	/// - Parameter other: The other range.
	///
	/// - Returns: `true` if `other` is fully contained within `self`, `false` otherwise.
	public func contains(_ other: Range<Bound>) -> Bool {
		self.lowerBound <= other.lowerBound && self.upperBound >= other.upperBound
	}
	
	/// Returns a Boolean value indicating whether a range is fully contained within `self`.
	///
	/// - Parameter other: The other range.
	///
	/// - Returns: `true` if `other` is fully contained within `self`, `false` otherwise.
	public func contains(_ other: ClosedRange) -> Bool {
		self.lowerBound <= other.lowerBound && self.upperBound > other.upperBound
	}
	
}
