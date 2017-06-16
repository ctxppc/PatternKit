// PatternKit © 2017 Constantino Tsarouhas

extension Sequence where Iterator.Element : Comparable {
	
	/// Returns a Boolean value indicating whether the sequence precedes another sequence in a lexicographical ordering, ordering a shorter sequence after the longer one when the short sequence is a prefix of the longer sequence.
	///
	/// - Parameter other: A sequence to compare to this sequence.
	/// - Parameter orderingShorterSequencesAfter: The unit value.
	
	/// - Returns: `true` if `self` precedes `self` in a lexicographical ordering and `self` is longer than `other`; otherwise, `false`.
	func lexicographicallyPrecedes<OtherSequence : Sequence>(_ other: OtherSequence, orderingShorterSequencesAfter: ()) -> Bool where OtherSequence.Iterator.Element == Iterator.Element {
		
		var elementsOfFirstSequence = self.makeIterator()
		var elementsOfSecondSequence = other.makeIterator()
		
		while let elementOfFirstSequence = elementsOfFirstSequence.next() {
			
			guard let elementOfSecondSequence = elementsOfSecondSequence.next() else { return true }
			
			if elementOfFirstSequence < elementOfSecondSequence {
				return true
			} else if elementOfFirstSequence > elementOfSecondSequence {
				return false
			}
			
		}
		
		return false
		
	}
	
}
