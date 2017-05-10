// PatternKit © 2017 Constantino Tsarouhas

extension Sequence {
	
	/// Returns the first element of the sequence.
	///
	/// Note that this method may consume the element if it does not support nondestructive iteration.
	///
	/// - Returns: The first element, or `nil` if the sequence is empty.
	func first() -> Iterator.Element? {
		var iterator = makeIterator()
		return iterator.next()
	}
	
	/// Returns the last element of the sequence.
	///
	/// Note that this method may consume the sequence if it does not support nondestructive iteration.
	///
	/// - Returns: The last element, or `nil` if the sequence is empty. This method does not return if the sequence is infinite.
	func last() -> Iterator.Element? {
		
		var current: Iterator.Element?
		for element in self {
			current = element
		}
		
		return current
		
	}
	
}

extension UnfoldSequence {
	
	/// Returns the last element of the sequence.
	///
	/// Note that this method redefines `last()` from Sequence with the additional guarantee that the sequence is nonempty and thus always has a last element (unless the sequence is infinite).
	///
	/// Also note that this method consumes the sequence.
	///
	/// - Returns: The last element. This method does not return if the sequence is infinite.
	func last() -> Element {
		return self.last()!
	}
	
}
