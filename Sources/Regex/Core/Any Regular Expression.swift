// PatternKit © 2017 Constantino Tsarouhas

/// A type-erased regular expression for some subject type.
public struct AnyRegularExpression<SubjectType : BidirectionalCollection> where SubjectType : Equatable {
	
	/// Creates a type-erased container for a given regular expression.
	///
	/// - Parameter regularExpression: The regular expression.
	public init<R : RegularExpression>(_ regularExpression: R) where R.Subject == SubjectType {
		wrapped = regularExpression
		symbolCollectionClosure = {
			AnyBidirectionalCollection(regularExpression.symbols)
		}
	}
	
	/// Creates a type-erased container for a given regular expression.
	///
	/// - Parameter regularExpression: The regular expression.
	public init(_ regularExpression: AnyRegularExpression<SubjectType>) {
		self = regularExpression
	}
	
	/// The wrapped regular expression.
	public let wrapped: Any
	
	/// The closure for symbol collections.
	private let symbolCollectionClosure: () -> AnyBidirectionalCollection<Symbol>
	
}
