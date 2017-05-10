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
	
	public func matches(proceedingFrom origin: Match<Collection>) -> AnyIterator<Match<Collection>> {
		
		var iteratorOfLeadingPattern = leadingPattern.matches(proceedingFrom: origin)
		guard let firstMatchForLeadingPattern = iteratorOfLeadingPattern.next() else { return none() }
		var matchForLeadingPattern = firstMatchForLeadingPattern
		
		func makeIteratorOfTrailingPattern() -> AnyIterator<Match<Collection>> {
			return trailingPattern.matches(proceedingFrom: matchForLeadingPattern)
		}
		var iteratorOfTrailingPattern = makeIteratorOfTrailingPattern()
		
		func next() -> Match<Collection>? {
			if let matchForTrailingPattern = iteratorOfTrailingPattern.next() {				// Next match in trailing found
				return matchForTrailingPattern
			} else if let nextMatchForLeadingPattern = iteratorOfLeadingPattern.next() {	// Next match in leading found
				matchForLeadingPattern = nextMatchForLeadingPattern
				iteratorOfTrailingPattern = makeIteratorOfTrailingPattern()
				return next()
			} else {																		// Both subpatterns exhausted
				return nil
			}
		}
		
		return AnyIterator(next)
		
	}
	
}

infix operator •

public func •<L : Pattern, R : Pattern>(l: L, r: R) -> Concatenation<L, R> {
	return Concatenation(l, r)
}

public func •<C : RangeReplaceableCollection>(l: Literal<C>, r: Literal<C>) -> Literal<C> {
	var l = l
	l.literal.append(contentsOf: r.literal)
	return l
}

public func •<C : RangeReplaceableCollection, P : Pattern>(l: Literal<C>, r: Concatenation<Literal<C>, P>) -> Concatenation<Literal<C>, P> {
	let newLiteral = l.literal.appending(contentsOf: r.leadingPattern.literal)
	return Concatenation(Literal(newLiteral), r.trailingPattern)
}

public func •<C : RangeReplaceableCollection, P : Pattern>(l: Concatenation<P, Literal<C>>, r: Literal<C>) -> Concatenation<P, Literal<C>> {
	let newLiteral = l.trailingPattern.literal.appending(contentsOf: r.literal)
	return Concatenation(l.leadingPattern, Literal(newLiteral))
}
