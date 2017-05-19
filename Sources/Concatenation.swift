// PatternKit © 2017 Constantino Tsarouhas

/// A pattern that matches two patterns sequentially.
public struct Concatenation<LeadingPattern : Pattern, TrailingPattern : Pattern> where LeadingPattern.Collection == TrailingPattern.Collection {
	
	/// Creates a concatenated pattern.
	///
	/// - Parameter leadingPattern: The pattern that matches the first part of the concatenation.
	/// - Parameter trailingPattern: The pattern that matches the part after the part matched by the leading pattern.
	public init(_ leadingPattern: LeadingPattern, _ trailingPattern: TrailingPattern) {
		self.leadingPattern = leadingPattern
		self.trailingPattern = trailingPattern
	}
	
	/// The pattern that matches the first part of the concatenation.
	public var leadingPattern: LeadingPattern
	
	/// The pattern that matches the part after the part matched by the leading pattern.
	public var trailingPattern: TrailingPattern
	
}

extension Concatenation : Pattern {
	
	public typealias Collection = LeadingPattern.Collection
	
	public func matches(base: Match<Collection>, direction: MatchingDirection) -> AnyIterator<Match<Collection>> {
		
		func makeIterator<A : Pattern, B : Pattern>(firstPattern: A, secondPattern: B) -> AnyIterator<Match<Collection>> where A.Collection == Collection, B.Collection == Collection {
			
			var iteratorOfFirstPattern = firstPattern.matches(base: base, direction: direction)
			guard let firstMatchForFirstPattern = iteratorOfFirstPattern.next() else { return none() }
			var matchForFirstPattern = firstMatchForFirstPattern
			
			func makeIteratorOfSecondPattern() -> AnyIterator<Match<Collection>> {
				return secondPattern.matches(base: matchForFirstPattern, direction: direction)
			}
			var iteratorOfSecondPattern = makeIteratorOfSecondPattern()
			
			func next() -> Match<Collection>? {
				if let matchForSecondPattern = iteratorOfSecondPattern.next() {				// Next match in second pattern found
					return matchForSecondPattern
				} else if let nextMatchForFirstPattern = iteratorOfFirstPattern.next() {	// Next match in first pattern found
					matchForFirstPattern = nextMatchForFirstPattern
					iteratorOfSecondPattern = makeIteratorOfSecondPattern()
					return next()
				} else {																	// Both patterns exhausted
					return nil
				}
			}
			
			return AnyIterator(next)
			
		}
		
		switch direction {
			case .forward:	return makeIterator(firstPattern: leadingPattern, secondPattern: trailingPattern)
			case .backward:	return makeIterator(firstPattern: trailingPattern, secondPattern: leadingPattern)
		}
		
	}
	
}

/// The general concatenation pattern.
infix operator • : AdditionPrecedence

/// Concatenates two arbitrary patterns.
public func •<L, R>(l: L, r: R) -> Concatenation<L, R> {
	return Concatenation(l, r)
}

/// Concatenates an arbitrary pattern with a literal collection.
public func •<P, C>(l: P, r: C) -> Concatenation<P, Literal<C>> {
	return Concatenation(l, Literal(r))
}

/// Concatenates a literal collection with an arbitrary pattern.
public func •<P, C>(l: C, r: P) -> Concatenation<Literal<C>, P> {
	return Concatenation(Literal(l), r)
}

/// Concatenates two literals into a new literal.
public func •<C : RangeReplaceableCollection>(l: Literal<C>, r: Literal<C>) -> Literal<C> {
	return Literal(l.literal.appending(contentsOf: r.literal))
}

/// Concatenates a literal with another literal within a concatenation.
public func •<C : RangeReplaceableCollection, P>(l: Literal<C>, r: Concatenation<Literal<C>, P>) -> Concatenation<Literal<C>, P> {
	let newLiteral = l.literal.appending(contentsOf: r.leadingPattern.literal)
	return Concatenation(Literal(newLiteral), r.trailingPattern)
}

/// Concatenates a literal within a concatenation with another literal.
public func •<C : RangeReplaceableCollection, P>(l: Concatenation<P, Literal<C>>, r: Literal<C>) -> Concatenation<P, Literal<C>> {
	let newLiteral = l.trailingPattern.literal.appending(contentsOf: r.literal)
	return Concatenation(l.leadingPattern, Literal(newLiteral))
}

/// Concatenates a literal collection with another literal collection into a literal pattern.
public func •<C : RangeReplaceableCollection>(l: C, r: C) -> Literal<C> {
	return Literal(l.appending(contentsOf: r))
}
