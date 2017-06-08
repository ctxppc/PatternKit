// PatternKit © 2017 Constantino Tsarouhas

/// A collection whose elements are ordered.
public protocol OrderedCollection : Collection {
	
	/// Returns an ordered subsequence of all elements that are strictly smaller than a given element.
	///
	/// - Complexity: *O(n)*, where *n* is the number of elements in `self`.
	///
	/// - Parameter upperBound: The element that is strictly greater than every element in the returned subsequence.
	///
	/// - Returns: A subsequence of all elements that are strictly smaller than `upperBound`.
	func prefix(upTo upperBound: Iterator.Element) -> SubSequence
	
	/// Returns an ordered subsequence of all elements that are greater than or equal to a given element.
	///
	/// - Complexity: *O(n)*, where *n* is the number of elements in `self`.
	///
	/// - Parameter lowerBound: The element that is smaller than or equal to every element in the returned subsequence.
	///
	/// - Returns: A subsequence of all elements that are greater than or equal to `lowerBound`.
	func suffix(from lowerBound: Iterator.Element) -> SubSequence
	
}

extension DefaultIndices : OrderedCollection {}
extension DefaultRandomAccessIndices : OrderedCollection {}
extension DefaultBidirectionalIndices : OrderedCollection {}
