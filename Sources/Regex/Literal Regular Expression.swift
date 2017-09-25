// PatternKit © 2017 Constantino Tsarouhas

/// A regular expression that represents a literal pattern.
public struct LiteralRegularExpression<Subject : BidirectionalCollection> where
	Subject.Element : Equatable,
	Subject.IndexDistance == Subject.SubSequence.IndexDistance,
	Subject.SubSequence : BidirectionalCollection {					// TODO: Remove constraints when recursive conformances land in Swift.
	
	/// Creates a pattern that matches an exact collection.
	///
	/// - Requires: `literal` is non-empty.
	///
	/// - Parameter literal: The collection that the pattern matches exactly.
	public init(_ literal: Subject) {
		precondition(!literal.isEmpty, "Empty literal")
		self.literal = literal
	}
	
	/// The collection that the pattern matches exactly.
	///
	/// - Invariant: `literal` is non-empty.
	public var literal: Subject {
		willSet {
			precondition(!newValue.isEmpty, "Empty literal")
		}
	}
	
}
