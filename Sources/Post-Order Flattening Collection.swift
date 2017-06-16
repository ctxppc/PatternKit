// PatternKit © 2017 Constantino Tsarouhas

/// A bidirectional collection that flattens a recursive bidirectional collection by visiting all subcollections in post-order.
public struct PostOrderFlatteningBidirectionalCollection<RecursiveCollection : BidirectionalCollection> where RecursiveCollection.Iterator.Element == RecursiveCollection {
	
	/// Creates a flattening collection over a collection.
	///
	/// - Parameter root: The root collection that is being flattened.
	/// - Parameter isLeaf: A function that determines whether a collection is a leaf node, given that collection's index path. The default always returns false.
	public init(root: RecursiveCollection, isLeaf: @escaping (Index.Path) -> Bool = { _ in false }) {
		self.root = root
		self.isLeaf = isLeaf
	}
	
	/// The root collection that is being flattened.
	public let root: RecursiveCollection
	
	/// A function that determines whether a collection is a leaf node, given the index path of the node.
	public var isLeaf: (Index.Path) -> Bool
	
}

extension PostOrderFlatteningBidirectionalCollection {
	
	/// Creates a flattening collection over a collection.
	///
	/// - Parameter root: The root collection that is being flattened.
	/// - Parameter maximumDepth: The maximum depth, inclusive. The root collection is at depth 0. If negative, the flattening collection is empty.
	public init(root: RecursiveCollection, maximumDepth: Int) {
		self.init(root: root, isLeaf: { path in path.count <= maximumDepth })
	}
	
}

extension PostOrderFlatteningBidirectionalCollection : BidirectionalCollection {
	
	public enum Index {
		
		public typealias Path = [RecursiveCollection.Index]
		
		/// A position to a nested collection.
		///
		/// - Invariant: The index path doesn't contain an end index or any other invalid indices for their associated collections.
		///
		/// - Parameter indexPath: The index path to the nested collection. The empty path refers to the base collection. The length of the path is the depth.
		case some(indexPath: Path)
		
		/// The position after the last element of the flattening collection.
		case end
		
	}
	
	public var startIndex: Index {
		return .some(indexPath: indexPathForLeadingCollection(containedInCollectionAt: []))
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> RecursiveCollection {
		guard case .some(indexPath: let indexPath) = index else { preconditionFailure("Index out of bounds") }
		return self[indexPath]
	}
	
	/// Accesses the collection at given index path.
	///
	/// - Parameter indexPath: The index path. The empty path refers to root.
	private subscript (indexPath: Index.Path) -> RecursiveCollection {
		return indexPath.reduce(root) { (subcollection, index) in
			subcollection[index]
		}
	}
	
	public func index(before index: Index) -> Index {
		
		guard case .some(indexPath: let indexPath) = index else { return .some(indexPath: []) }
		
		if let indexPathOfLastChild = indexPathOfLastChildCollection(containedInCollectionAt: indexPath) {
			return .some(indexPath: indexPathOfLastChild)
		}
		
		for (indexPathOfParent, indexOfCurrent) in indexPath.unfoldingBackwards() {	// indexPathOfParent becomes empty when parent is the root; root itself never is current
			let parent = self[indexPathOfParent]
			if indexOfCurrent > parent.startIndex {
				let indexOfSibling = parent.index(before: indexOfCurrent)
				return .some(indexPath: indexPathOfParent.appending(indexOfSibling))
			}
		}
		
		preconditionFailure("Index out of bounds")
		
	}
	
	public func index(after index: Index) -> Index {
		
		guard case .some(indexPath: let indexPath) = index else { preconditionFailure("Index out of bounds") }
		
		guard let (indexPathOfParent, indexOfCurrent) = indexPath.poppingLast() else { return .end }
		
		let parent = self[indexPathOfParent]
		let indexOfSibling = parent.index(after: indexOfCurrent)
		guard indexOfSibling < parent.endIndex else { return .some(indexPath: indexPathOfParent) }
		
		return .some(indexPath: indexPathForLeadingCollection(containedInCollectionAt: indexPathOfParent.appending(indexOfSibling)))
		
	}
	
	/// Returns the index path for the last collection contained within a collection at a given index path.
	///
	/// - Parameter indexPathForParent: The index path of the collection whose last child collection's index path to determine.
	///
	/// - Returns: The index path for the last collection contained within a collection at `indexPathForParent`; or `nil` if the collection at `indexPathForParent` is empty or is a leaf node.
	private func indexPathOfLastChildCollection(containedInCollectionAt indexPathForParent: Index.Path) -> Index.Path? {
		
		guard !isLeaf(indexPathForParent) else { return nil }
		
		let parent = self[indexPathForParent]
		let endIndex = parent.endIndex
		guard endIndex > parent.startIndex else { return nil }
		
		return indexPathForParent.appending(parent.index(before: endIndex))
		
	}
	
	/// Returns the index path for the leading (left-most) collection contained within a collection at a given index path.
	///
	/// - Parameter indexPath: The index path of the collection whose leading collection's index path to determine.
	///
	/// - Returns: The index path for the leading (left-most) collection contained within a collection at `indexPath`; or `indexPath` if the collection at `indexPath` is empty or is a leaf node.
	private func indexPathForLeadingCollection(containedInCollectionAt indexPath: Index.Path) -> Index.Path {
		
		guard !isLeaf(indexPath) else { return indexPath }
		
		let base = self[indexPath]	// TODO: Remove redundant computation of the base in a recursive context
		let startIndexInBase = base.startIndex
		guard startIndexInBase < base.endIndex else { return indexPath }
		
		return indexPathForLeadingCollection(containedInCollectionAt: indexPath.appending(startIndexInBase))
		
	}
	
}

extension PostOrderFlatteningBidirectionalCollection.Index : Comparable {
	
	public static func <<C>(leftIndex: PostOrderFlatteningBidirectionalCollection<C>.Index, rightIndex: PostOrderFlatteningBidirectionalCollection<C>.Index) -> Bool {
		switch (leftIndex, rightIndex) {
			case (.some(indexPath: let leftPath), .some(indexPath: let rightPath)):	return leftPath.lexicographicallyPrecedes(rightPath, orderingShorterSequencesAfter: ())
			case (.some, .end):														return true
			default:																return false
		}
	}
	
	public static func ==<C>(index: PostOrderFlatteningBidirectionalCollection<C>.Index, otherIndex: PostOrderFlatteningBidirectionalCollection<C>.Index) -> Bool {
		switch (index, otherIndex) {
			case (.some(indexPath: let path), .some(indexPath: let otherPath)):	return path == otherPath
			case (.end, .end):													return true
			default:															return false
		}
	}
	
}
