// PatternKit © 2017 Constantino Tsarouhas

extension BidirectionalCollection where Iterator.Element : Equatable {
	
	/// Returns a Boolean value indicating whether the collection's last elements are the same as the elements from another collection.
	///
	/// - Parameter suffix: The elements.
	///
	/// - Returns: `true` if the last elements in `self` are `suffix`, otherwise `false`.
	func ends<Suffix : BidirectionalCollection>(with suffix: Suffix) -> Bool where Suffix.Iterator.Element == Iterator.Element, Suffix.IndexDistance == IndexDistance {
		
		guard self.count >= suffix.count else { return false }
		
		for (element1, element2) in zip(suffix.reversed(), self.reversed()) {
			guard element1 == element2 else { return false }
		}
		
		return true
		
	}
	
}

extension BidirectionalCollection where SubSequence == Self {
	
	/// Returns a sequence of popped last elements and the resulting shortened collections.
	///
	/// - Returns: A sequence of pairs of the shortened collection and the popped element.
	func unfoldingBackwards() -> UnfoldSequence<(Self, Iterator.Element), Self> {
		return sequence(state: self) { collection -> (Self, Iterator.Element)? in
			guard let element = collection.popLast() else { return nil }
			return (collection, element)
		}
	}
	
	/// Returns the popped last element and the resulting shortened collection.
	///
	/// - Returns: A tuple containing `self` except for the last element, and the last element; or `nil` if `self` is empty.
	func poppingLast() -> (poppedCollection: Self, poppedElement: Iterator.Element)? {
		var collection = self
		guard let element = collection.popLast() else { return nil }
		return (collection, element)
	}
	
}

extension BidirectionalCollection where Iterator.Element == Self {
	
	/// Returns a pre-order flattening collection over the collection.
	///
	/// - Parameter isLeaf: A function that determines whether a collection is a leaf node, given that collection's index path. The default always returns false.
	///
	/// - Returns: A pre-order flattening collection over `self`.
	public func flattenedInPreorder(isLeaf: @escaping (PreorderFlatteningBidirectionalCollection<Self>.Index.Path) -> Bool = { _ in false }) -> PreorderFlatteningBidirectionalCollection<Self> {
		return PreorderFlatteningBidirectionalCollection(root: self, isLeaf: isLeaf)
	}
	
	/// Returns a pre-order flattening collection over the collection.
	///
	/// - Parameter maximumDepth: The maximum depth, inclusive. `self` is at depth 0. If negative, the flattening collection is empty.
	///
	/// - Returns: A pre-order flattening collection over `self`.
	public func flattenedInPreorder(maximumDepth: Int) -> PreorderFlatteningBidirectionalCollection<Self> {
		return PreorderFlatteningBidirectionalCollection(root: self, maximumDepth: maximumDepth)
	}
	
	/// Returns a post-order flattening collection over the collection.
	///
	/// - Parameter isLeaf: A function that determines whether a collection is a leaf node, given that collection's index path. The default always returns false.
	///
	/// - Returns: A post-order flattening collection over `self`.
	public func flattenedInPostorder(isLeaf: @escaping (PostorderFlatteningBidirectionalCollection<Self>.Index.Path) -> Bool = { _ in false }) -> PostorderFlatteningBidirectionalCollection<Self> {
		return PostorderFlatteningBidirectionalCollection(root: self, isLeaf: isLeaf)
	}
	
	/// Returns a post-order flattening collection over the collection.
	///
	/// - Parameter maximumDepth: The maximum depth, inclusive. `self` is at depth 0. If negative, the flattening collection is empty.
	///
	/// - Returns: A post-order flattening collection over `self`.
	public func flattenedInPostorder(maximumDepth: Int) -> PostorderFlatteningBidirectionalCollection<Self> {
		return PostorderFlatteningBidirectionalCollection(root: self, maximumDepth: maximumDepth)
	}
	
}
