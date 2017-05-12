// PatternKit © 2017 Constantino Tsarouhas

extension RangeReplaceableCollection {
	
	/// Returns a copy of the collection with the contents of a given sequence appended to it.
	///
	/// - Parameter other: The sequence whose elements to append.
	///
	/// - Returns: A copy of the collection with the contents of `other` appended to it.
	func appending<S : Sequence>(contentsOf other: S) -> Self where S.Iterator.Element == Iterator.Element {
		return withCopy(of: self, mutator: Self.append, argument: other)
	}
	
}

extension BidirectionalCollection where Iterator.Element : Equatable {
	
	/// Returns a Boolean value indicating whether the collection's last elements are the same as the elements from another collection.
	///
	/// - Parameter suffix: The elements.
	///
	/// - Returns: `true` if the last elements in `self` are `suffix`, otherwise `false`.
	func ends<Suffix : BidirectionalCollection>(with suffix: Suffix) -> Bool where Suffix.Iterator.Element == Self.Iterator.Element, Suffix.IndexDistance == Self.IndexDistance {
		
		guard self.count >= suffix.count else { return false }
		
		for (element1, element2) in zip(suffix.reversed(), self.reversed()) {
			guard element1 == element2 else { return false }
		}
		
		return true
		
	}
	
}
