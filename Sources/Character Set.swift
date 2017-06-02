// PatternKit © 2017 Constantino Tsarouhas

import Foundation

extension CharacterSet : Pattern {
	
	public typealias MatchCollection = SingularMatchCollection<String.CharacterView>
	
	public func matches(base: Match<String.CharacterView>, direction: MatchingDirection) -> AnyBidirectionalCollection<Match<String.CharacterView>> {	// TODO: Remove in Swift 4, after removing requirement in Pattern
		return AnyBidirectionalCollection(matches(base: base, direction: direction) as SingularMatchCollection)
	}
	
	public func matches(base: Match<String.CharacterView>, direction: MatchingDirection) -> SingularMatchCollection<String.CharacterView> {
		
		guard let character = base.remainingElements(direction: direction).first else { return nil }
		
		let scalars = String(character).unicodeScalars
		guard let scalar = scalars.first, scalars.count == 1, contains(scalar) else { return nil }
		
		return SingularMatchCollection(resultMatch: base.movingInputPosition(distance: 1, direction: direction))
		
	}
	
}
