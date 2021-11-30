// PatternKit © 2017–21 Constantino Tsarouhas

/// A pattern that matches an exact subcollection.
public struct Literal<Subject : BidirectionalCollection> where Subject.Element : Equatable {
	
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
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> SingularMatchCollection<Subject> {
		guard base.remainingElements(direction: .forward).starts(with: literal) else { return nil }
		return SingularMatchCollection(resultMatch: base.movingInputPosition(distance: literal.count, direction: .forward))
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> SingularMatchCollection<Subject> {
		guard base.remainingElements(direction: .backward).ends(with: literal) else { return nil }
		return SingularMatchCollection(resultMatch: base.movingInputPosition(distance: literal.count, direction: .backward))
	}
	
	// TODO: Potentially optimise by implementing the heuristic functions, using an efficient substring finding algorithm
	
}

extension Literal where Subject : RangeReplaceableCollection {
	
	/// Creates a literal pattern over some elements.
	///
	/// - Parameter elements: The elements to match.
	public init(_ elements: Subject.Element...) {
		self.init(Subject(elements))
	}
	
}

extension Literal : ExpressibleByUnicodeScalarLiteral where Subject : ExpressibleByUnicodeScalarLiteral {
	public typealias UnicodeScalarLiteralType = Subject.UnicodeScalarLiteralType
	public init(unicodeScalarLiteral: Subject.UnicodeScalarLiteralType) {
		self.init(Subject(unicodeScalarLiteral: unicodeScalarLiteral))
	}
}

extension Literal : ExpressibleByExtendedGraphemeClusterLiteral where Subject : ExpressibleByExtendedGraphemeClusterLiteral {
	public typealias ExtendedGraphemeClusterLiteralType = Subject.ExtendedGraphemeClusterLiteralType
	public init(extendedGraphemeClusterLiteral: Subject.ExtendedGraphemeClusterLiteralType) {
		self.init(Subject(extendedGraphemeClusterLiteral: extendedGraphemeClusterLiteral))
	}
}

extension Literal : ExpressibleByStringLiteral where Subject : ExpressibleByStringLiteral {
	public typealias StringLiteralType = Subject.StringLiteralType
	public init(stringLiteral: Subject.StringLiteralType) {
		self.init(Subject(stringLiteral: stringLiteral))
	}
}
