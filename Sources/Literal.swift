// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches an exact subsequence.
public struct Literal<Collection : BidirectionalCollection> where
	Collection.Iterator.Element : Equatable,
	Collection.Iterator.Element == Collection.SubSequence.Iterator.Element,
	Collection.IndexDistance == Collection.SubSequence.IndexDistance,
	Collection.SubSequence : BidirectionalCollection {
	
	/// Creates a literal-matching pattern.
	///
	/// - Parameter literal: The literal that the pattern matches.
	public init(_ literal: Collection) {
		self.literal = literal
	}
	
	/// The literal that the pattern matches.
	public var literal: Collection
	
}

extension Literal : Pattern {
	
	public func matches(base: Match<Collection>, direction: MatchingDirection) -> AnyIterator<Match<Collection>> {
		
		switch direction {
			case .forward:	guard base.remainingElements(direction: .forward).starts(with: literal) else { return none() }
			case .backward:	guard base.remainingElements(direction: .forward).ends(with: literal) else { return none() }
		}
		
		return one(base.movingInputPosition(distance: literal.count, direction: direction))
		
	}
	
}

public struct UnicodeScalarStringLiteral {
	
	/// Creates a Unicode scalar string literal pattern.
	fileprivate init(literal: Literal<String.UnicodeScalarView>) {
		innerLiteral = literal
	}
	
	/// The inner literal.
	public var innerLiteral: Literal<String.UnicodeScalarView>
	
}

extension UnicodeScalarStringLiteral : ExpressibleByStringLiteral {
	
	public init(extendedGraphemeClusterLiteral value: String) {
		innerLiteral = Literal(value.unicodeScalars)
	}
	
	public init(stringLiteral value: String) {
		innerLiteral = Literal(value.unicodeScalars)
	}
	
	public init(unicodeScalarLiteral value: String) {
		innerLiteral = Literal(value.unicodeScalars)
	}
	
}

extension UnicodeScalarStringLiteral : Pattern {
	
	public func matches(base: Match<String.UnicodeScalarView>, direction: MatchingDirection) -> AnyIterator<Match<String.UnicodeScalarView>> {
		return innerLiteral.matches(base: base, direction: direction)
	}
	
}

public struct StringLiteral {
	
	/// Creates a Unicode scalar string literal pattern.
	fileprivate init(_ literal: Literal<String.CharacterView>) {
		innerLiteral = literal
	}
	
	/// The inner literal.
	public var innerLiteral: Literal<String.CharacterView>
	
}

extension StringLiteral : ExpressibleByStringLiteral {
	
	public init(extendedGraphemeClusterLiteral value: String) {
		innerLiteral = Literal(value.characters)
	}
	
	public init(stringLiteral value: String) {
		innerLiteral = Literal(value.characters)
	}
	
	public init(unicodeScalarLiteral value: String) {
		innerLiteral = Literal(value.characters)
	}
	
}

extension StringLiteral : Pattern {
	
	public func matches(base: Match<String.CharacterView>, direction: MatchingDirection) -> AnyIterator<Match<String.CharacterView>> {
		return innerLiteral.matches(base: base, direction: direction)
	}
	
}
