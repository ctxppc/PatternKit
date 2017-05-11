// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches an exact subsequence.
public struct Literal<Collection : BidirectionalCollection> where
	Collection.Iterator.Element : Equatable,
	Collection.Iterator.Element == Collection.SubSequence.Iterator.Element {
	
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
	
	public func matches(proceedingFrom origin: Match<Collection>) -> AnyIterator<Match<Collection>> {
		if origin.collectionFollowingInputPosition.starts(with: literal) {
			return one(origin.movingInputPosition(distance: literal.distance(from: literal.startIndex, to: literal.endIndex)))
		} else {
			return none()
		}
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
