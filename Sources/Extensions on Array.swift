// PatternKit © 2017 Constantino Tsarouhas

extension Array {
	
	/// Returns a sequence of popped last elements and the resulting shortened arrays.
	///
	/// - Returns: A sequence of pairs of the shortened arrays and the popped element.
	func unfoldingBackwards() -> UnfoldSequence<(Array, Element), Array> {
		return sequence(state: self) { array -> (Array, Element)? in
			guard let element = array.popLast() else { return nil }
			return (array, element)
		}
	}
	
	/// Returns the popped last element and the resulting shortened array.
	///
	/// - Returns: A tuple containing `self` except for the last element, and the last element; or `nil` if `self` is empty.
	func poppingLast() -> (poppedCollection: Array, poppedElement: Element)? {
		var array = self
		guard let element = array.popLast() else { return nil }
		return (array, element)
	}
	
}
