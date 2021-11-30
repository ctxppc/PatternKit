// PatternKit © 2017–21 Constantino Tsarouhas

import Foundation
import PatternKitCore

extension CharacterSet : PatternKitCore.Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Substring>) -> SingularMatchCollection<Substring> {
		
		guard let character = base.remainingElements(direction: .forward).first else { return nil }
		
		let scalars = character.unicodeScalars
		guard let scalar = scalars.first, scalars.count == 1, contains(scalar) else { return nil }
		
		return .init(resultMatch: base.movingInputPosition(distance: 1, direction: .forward))
		
	}
	
	public func backwardMatches(recedingFrom base: Match<Substring>) -> SingularMatchCollection<Substring> {
		
		guard let character = base.remainingElements(direction: .backward).last else { return nil }
		
		let scalars = character.unicodeScalars
		guard let scalar = scalars.first, scalars.count == 1, contains(scalar) else { return nil }
		
		return .init(resultMatch: base.movingInputPosition(distance: 1, direction: .backward))
		
	}
	
}
