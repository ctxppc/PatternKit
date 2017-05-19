// PatternKit © 2017 Constantino Tsarouhas

import Foundation

extension CharacterSet : Pattern {
	
	public func matches(base: Match<String.CharacterView>, direction: MatchingDirection) -> AnyIterator<Match<String.CharacterView>> {
		
		guard let character = base.remainingElements(direction: direction).first else { return none() }
		
		let scalars = String(character).unicodeScalars
		guard let scalar = scalars.first, scalars.count == 1, contains(scalar) else { return none() }
		
		return one(base.movingInputPosition(distance: 1, direction: direction))
		
	}
	
}

public func ...(l: UnicodeScalar, r: UnicodeScalar) -> CharacterSet {
	return CharacterSet(charactersIn: l...r)
}

public struct UnicodeScalarSetPattern {
	
	/// Creates a scalar set pattern.
	init(_ characterSet: CharacterSet) {
		self.characterSet = characterSet
	}
	
	/// The characters that the pattern matches.
	public var characterSet: CharacterSet
	
}

extension UnicodeScalarSetPattern : Pattern {
	
	public func matches(base: Match<String.UnicodeScalarView>, direction: MatchingDirection) -> AnyIterator<Match<String.UnicodeScalarView>> {
		guard let scalar = base.remainingElements(direction: direction).first else { return none() }
		if characterSet.contains(scalar) {
			return one(base.movingInputPosition(distance: 1, direction: direction))
		} else {
			return none()
		}
	}
	
}

public func ...(l: UnicodeScalar, r: UnicodeScalar) -> UnicodeScalarSetPattern {
	return UnicodeScalarSetPattern(l...r)
}
