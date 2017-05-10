// PatternKit © 2017 Constantino Tsarouhas

extension RangeReplaceableCollection {
	
	func appending<S : Sequence>(contentsOf other: S) -> Self where S.Iterator.Element == Iterator.Element {
		var collection = self
		collection.append(contentsOf: other)
		return self
	}
	
}
