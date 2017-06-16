// PatternKit © 2017 Constantino Tsarouhas

extension RangeReplaceableCollection {
	
	/// Returns a copy of the collection with the contents of a given sequence appended to it.
	///
	/// - Parameter other: The sequence whose elements to append.
	///
	/// - Returns: A copy of the collection with the contents of `other` appended to it.
	func appending(_ element: Iterator.Element) -> Self {
		return withCopy(of: self, mutator: Self.append, argument: element)
	}
	
	/// Returns a copy of the collection with the contents of a given sequence appended to it.
	///
	/// - Parameter other: The sequence whose elements to append.
	///
	/// - Returns: A copy of the collection with the contents of `other` appended to it.
	func appending<S : Sequence>(contentsOf other: S) -> Self where S.Iterator.Element == Iterator.Element {
		return withCopy(of: self, mutator: Self.append, argument: other)
	}
	
}
