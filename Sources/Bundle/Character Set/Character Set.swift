// PatternKit © 2017 Constantino Tsarouhas

import Foundation
import PatternKitCore

extension CharacterSet : PatternKitCore.Pattern {
	
	public func forwardMatches(enteringFrom base: Match<String>) -> SingularMatchCollection<String> {
		
		guard let character = base.remainingElements(direction: .forward).first else { return nil }
		
		let scalars = character.unicodeScalars
		guard let scalar = scalars.first, scalars.count == 1, contains(scalar) else { return nil }
		
		return SingularMatchCollection(resultMatch: base.movingInputPosition(distance: 1, direction: .forward))
		
	}
	
	public func backwardMatches(recedingFrom base: Match<String>) -> SingularMatchCollection<String> {
		
		guard let character = base.remainingElements(direction: .backward).last else { return nil }
		
		let scalars = character.unicodeScalars
		guard let scalar = scalars.first, scalars.count == 1, contains(scalar) else { return nil }
		
		return SingularMatchCollection(resultMatch: base.movingInputPosition(distance: 1, direction: .backward))
		
	}
	
}
