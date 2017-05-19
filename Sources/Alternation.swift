// PatternKit © 2017 Constantino Tsarouhas

import Foundation

/// A pattern that matches any one of two patterns.
public struct Alternation<MainPattern : Pattern, AlternativePattern : Pattern> where MainPattern.Collection == AlternativePattern.Collection {
	
	/// Creates an alternated pattern.
	///
	/// - Parameter leadingPattern: The pattern that matches the first part of the concatenation.
	/// - Parameter trailingPattern: The pattern that matches the part after the part matched by the leading pattern.
	public init(_ mainPattern: MainPattern, _ alternativePattern: AlternativePattern) {
		self.mainPattern = mainPattern
		self.alternativePattern = alternativePattern
	}
	
	/// The pattern whose matches are generated first.
	public var mainPattern: MainPattern
	
	/// The pattern whose matches are generated after those of the main pattern.
	public var alternativePattern: AlternativePattern
	
}

extension Alternation : Pattern {
	
	public typealias Collection = MainPattern.Collection
	
	public func matches(base: Match<Collection>, direction: MatchingDirection) -> AnyIterator<Match<Collection>> {
		
		func makeIterator<A : Pattern, B : Pattern>(firstPattern: A, secondPattern: B) -> AnyIterator<Match<Collection>> where A.Collection == Collection, B.Collection == Collection {
			
			var state = Iterator<Collection>.initial
			func next() -> Match<Collection>? {
				switch state {
					
					case .initial:
					state = .matchingFirstPattern(iterator: firstPattern.matches(base: base, direction: direction))
					return next()
					
					case .matchingFirstPattern(iterator: let iterator):
					if let match = iterator.next() {
						return match
					} else {
						state = .matchingSecondPattern(iterator: secondPattern.matches(base: base, direction: direction))
						return next()
					}
					
					case .matchingSecondPattern(iterator: let iterator):
					if let match = iterator.next() {
						return match
					} else {
						state = .done
						return next()
					}
					
					case .done:
					return nil
					
				}
			}
			
			return AnyIterator(next)
			
		}
		
		switch direction {
			case .forward:	return makeIterator(firstPattern: mainPattern, secondPattern: alternativePattern)
			case .backward:	return makeIterator(firstPattern: alternativePattern, secondPattern: mainPattern)
		}
		
	}
	
}

private enum Iterator<Collection : BidirectionalCollection> {
	case initial
	case matchingFirstPattern(iterator: AnyIterator<Match<Collection>>)
	case matchingSecondPattern(iterator: AnyIterator<Match<Collection>>)
	case done
}

/// Forms an alternation between two arbitrary patterns.
public func |<L, R>(main: L, alternative: R) -> Alternation<L, R> {
	return Alternation(main, alternative)
}

/// Forms an alternation between an arbitrary pattern and a literal collection.
public func |<P, C>(pattern: P, collection: C) -> Alternation<P, Literal<C>> {
	return Alternation(pattern, Literal(collection))
}

/// Forms an alternation between a literal collection and an arbitrary pattern.
public func |<P, C>(collection: C, pattern: P) -> Alternation<Literal<C>, P> {
	return Alternation(Literal(collection), pattern)
}

/// Forms an alternation between two literal collections.
public func |<C>(firstCollection: C, secondCollection: C) -> Alternation<Literal<C>, Literal<C>> {
	return Alternation(Literal(firstCollection), Literal(secondCollection))
}

/// Forms an alternation between two character sets.
public func |(firstSet: CharacterSet, secondSet: CharacterSet) -> CharacterSet {
	return firstSet.union(secondSet)
}

/// Forms an alternation between a character set and a character.
public func |(set: CharacterSet, character: UnicodeScalar) -> CharacterSet {
	return withCopy(of: set, mutator: CharacterSet.insert(_:), argument: character)
}

/// Forms an alternation between a character and a character set.
public func |(character: UnicodeScalar, set: CharacterSet) -> CharacterSet {
	return withCopy(of: set, mutator: CharacterSet.insert(_:), argument: character)
}

/// Forms an alternation between two characters.
public func |(firstCharacter: UnicodeScalar, secondCharacter: UnicodeScalar) -> CharacterSet {
	return CharacterSet([firstCharacter, secondCharacter])
}

/// Forms an alternation between two characters.
public func |(firstCharacter: UnicodeScalar, secondCharacter: UnicodeScalar) -> UnicodeScalarSetPattern {
	return UnicodeScalarSetPattern(CharacterSet([firstCharacter, secondCharacter]))
}

/// Forms an alternation between a character set and a character.
public func |(set: UnicodeScalarSetPattern, character: UnicodeScalar) -> UnicodeScalarSetPattern {
	return UnicodeScalarSetPattern(withCopy(of: set.characterSet, mutator: CharacterSet.insert(_:), argument: character))
}

/// Forms an alternation between a character and a character set.
public func |(character: UnicodeScalar, set: UnicodeScalarSetPattern) -> UnicodeScalarSetPattern {
	return UnicodeScalarSetPattern(withCopy(of: set.characterSet, mutator: CharacterSet.insert(_:), argument: character))
}

/// Forms an alternation between two character sets.
public func |(firstSet: UnicodeScalarSetPattern, secondSet: UnicodeScalarSetPattern) -> UnicodeScalarSetPattern {
	return UnicodeScalarSetPattern(firstSet.characterSet.union(secondSet.characterSet))
}
