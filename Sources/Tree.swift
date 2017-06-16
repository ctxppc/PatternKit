// PatternKit © 2017 Constantino Tsarouhas

internal struct Tree<Value> {
	
	/// Creates a tree.
	init(_ value: Value, _ children: [Tree]) {
		self.value = value
		self.children = children
	}
	
	/// The value associated with the tree.
	var value: Value
	
	/// The children.
	var children: [Tree]
	
}

extension Tree : BidirectionalCollection {
	
	typealias Index = Array<Tree>.Index
	
	var startIndex: Index {
		return children.startIndex
	}
	
	var endIndex: Index {
		return children.endIndex
	}
	
	func index(before index: Index) -> Index {
		return children.index(before: index)
	}
	
	func index(after index: Index) -> Index {
		return children.index(after: index)
	}
	
	subscript (index: Index) -> Tree {
		get { return children[index] }
		set { children[index] = newValue }
	}
	
}
