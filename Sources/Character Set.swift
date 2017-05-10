// PatternKit © 2017 Constantino Tsarouhas

import Foundation

extension CharacterSet : Pattern {
	
	public func matches(proceedingFrom origin: Match<String.CharacterView>) -> AnyIterator<Match<String.CharacterView>> {
		
		guard let character = origin.remainingCollection.first else { return none() }
		
		let scalars = String(character).unicodeScalars
		guard scalars.count == 1 else { return none() }
		
		if contains(scalars.first!) {
			return one(origin.advancingInputPosition(distance: 1))
		} else {
			return none()
		}
		
	}
	
}

public struct UnicodeScalarSetPattern {
	
	/// The characters that the pattern matches.
	public var characterSet: CharacterSet
	
}

extension UnicodeScalarSetPattern : Pattern {
	
	public func matches(proceedingFrom origin: Match<String.UnicodeScalarView>) -> AnyIterator<Match<String.UnicodeScalarView>> {
		guard let scalar = origin.remainingCollection.first else { return none() }
		if characterSet.contains(scalar) {
			return one(origin.advancingInputPosition(distance: 1))
		} else {
			return none()
		}
	}
	
}

public func ...(l: UnicodeScalar, r: UnicodeScalar) -> CharacterSet {
	return CharacterSet(charactersIn: l...r)
}

public func ...(l: UnicodeScalar, r: UnicodeScalar) -> UnicodeScalarSetPattern {
	return UnicodeScalarSetPattern(characterSet: l...r)
}
