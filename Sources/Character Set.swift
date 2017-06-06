// PatternKit © 2017 Constantino Tsarouhas

import Foundation

extension CharacterSet : Pattern {
	
	public func matches(base: Match<String.CharacterView>, direction: MatchingDirection) -> SingularMatchCollection<String.CharacterView> {
		
		guard let character = base.remainingElements(direction: direction).first else { return nil }
		
		let scalars = String(character).unicodeScalars
		guard let scalar = scalars.first, scalars.count == 1, contains(scalar) else { return nil }
		
		return SingularMatchCollection(resultMatch: base.movingInputPosition(distance: 1, direction: direction))
		
	}
	
}
