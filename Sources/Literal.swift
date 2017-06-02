// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches an exact subcollection.
public struct Literal<Subject : BidirectionalCollection> where
	Subject.Iterator.Element : Equatable,
	Subject.Iterator.Element == Subject.SubSequence.Iterator.Element,
	Subject.IndexDistance == Subject.SubSequence.IndexDistance,
	Subject.SubSequence : BidirectionalCollection {
	
	/// Creates a pattern that matches an exact collection.
	///
	/// - Parameter literal: The collection that the pattern matches exactly.
	public init(_ literal: Subject) {
		self.literal = literal
	}
	
	/// The collection that the pattern matches exactly.
	public var literal: Subject
	
}

extension Literal : Pattern {
	
	public typealias MatchCollection = SingularMatchCollection<Subject>
	
	public func matches(base: Match<Subject>, direction: MatchingDirection) -> AnyBidirectionalCollection<Match<Subject>> {		// TODO: Remove in Swift 4, after removing requirement in Pattern
		return AnyBidirectionalCollection(matches(base: base, direction: direction) as SingularMatchCollection)
	}
	
	public func matches(base: Match<Subject>, direction: MatchingDirection) -> SingularMatchCollection<Subject> {
		
		let hasMatch: Bool
		switch direction {
			case .forward:	hasMatch = base.remainingElements(direction: .forward).starts(with: literal)
			case .backward: hasMatch = base.remainingElements(direction: .forward).ends(with: literal)
			
		}
		
		return hasMatch ? SingularMatchCollection(resultMatch: base.movingInputPosition(distance: literal.count, direction: direction)) : nil
		
	}
	
}

extension Literal /* : ExpressibleByStringLiteral */ where Subject == String.CharacterView {	// TODO: Add conformance in Swift 4
	
//	public init(_ literal: String) {															// TODO: Uncomment when bugfix lands, or remove when conformance is added
//		self.literal = literal.characters
//	}
	
	// TODO: Implement protocol conformance in Swift 4
	
}

public func literal(_ literal: String) -> Literal<String.CharacterView> {						// TODO: Remove when bugfix lands for above initialiser or when above conformance is added
	return Literal(literal.characters)
}
