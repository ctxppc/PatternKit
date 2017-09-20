// PatternKit © 2017 Constantino Tsarouhas

/// A type-erased unary regular expression for some subject type.
public struct AnyUnaryRegularExpression<SubjectType : BidirectionalCollection> where SubjectType : Equatable {
	
	/// Creates a type-erased container for a given unary regular expression.
	///
	/// - Parameter regularExpression: The unary regular expression.
	public init<R : UnaryRegularExpression>(_ regularExpression: R) where R.Subject == SubjectType {
		
		wrapped = regularExpression
		
		symbolCollectionClosure = {
			AnyBidirectionalCollection(regularExpression.symbols)
		}
		
		subexpressionClosure = {
			AnyRegularExpression(regularExpression.subexpression)
		}
		
		subexpressionSubstitutor = { untypedSubexpression in
			
			guard let typedSubexpression = untypedSubexpression.wrapped as? R.Subexpression else { fatalError("Incompatible subexpression type") }
			
			var newRegularExpression = regularExpression
			newRegularExpression.subexpression = typedSubexpression
			
			return AnyUnaryRegularExpression(newRegularExpression)
			
		}
		
	}
	
	/// Creates a type-erased container for a given unary regular expression.
	///
	/// - Parameter regularExpression: The unary regular expression.
	public init(_ regularExpression: AnyUnaryRegularExpression) {
		self = regularExpression
	}
	
	/// The wrapped regular expression.
	public let wrapped: Any
	
	/// The closure for symbol collections.
	private let symbolCollectionClosure: () -> AnyBidirectionalCollection<Symbol>
	
	/// The closure for the subexpression.
	private let subexpressionClosure: () -> AnyRegularExpression<SubjectType>
	
	/// The closure for substituting the subexpression, taking the new subexpression and returning a new type-erased unary regular expression with the given subexpression.
	private let subexpressionSubstitutor: (_ subexpression: AnyRegularExpression<SubjectType>) -> AnyUnaryRegularExpression
	
}

extension AnyUnaryRegularExpression : UnaryRegularExpression {
	
	public typealias Subject = SubjectType
	
	public typealias Subexpression = AnyRegularExpression<SubjectType>
	
	public var symbols: AnyBidirectionalCollection<Symbol> {
		return symbolCollectionClosure()
	}
	
	public var subexpression: AnyRegularExpression<SubjectType> {
		get { return subexpressionClosure() }
		set { self = subexpressionSubstitutor(newValue) }
	}
	
}
