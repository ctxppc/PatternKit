// PatternKit © 2017–21 Constantino Tsarouhas

/// Creates a range pattern.
///
/// - Parameter lowerBound: The smallest element that is matched.
/// - Parameter upperBound: The element greater than the largest element that is matched.
///
/// - Returns: A range pattern matching elements between `lowerBound` and `upperBound`, exclusive.
public func ..< <Subject>(lowerBound: Subject.Element, upperBound: Subject.Element) -> RangePattern<Subject> {
	return RangePattern(lowerBound..<upperBound)
}

/// Creates a range pattern.
///
/// - Parameter lowerBound: The smallest element that is matched.
/// - Parameter upperBound: The largest element that is matched.
///
/// - Returns: A range pattern matching elements between `lowerBound` and `upperBound`, inclusive.
public func ... <Subject>(lowerBound: Subject.Element, upperBound: Subject.Element) -> RangePattern<Subject> {
	return RangePattern(lowerBound...upperBound)
}
