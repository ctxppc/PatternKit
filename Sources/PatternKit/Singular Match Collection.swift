// PatternKit © 2017–21 Constantino Tsarouhas

/// A collection that contains at most one match.
public struct SingularMatchCollection<Subject : BidirectionalCollection> where Subject.Element : Equatable {
	
	/// The match resulting from matching the pattern, or `nil` if the pattern failed to match.
	public let resultMatch: Match<Subject>?
	
}

extension SingularMatchCollection : ExpressibleByNilLiteral {
	public init(nilLiteral: ()) {
		self.init(resultMatch: nil)
	}
}

extension SingularMatchCollection : BidirectionalCollection {
	
	public enum Index : Equatable {
		
		/// The position of the result match if it exists, otherwise the end index of the collection.
		case resultMatch
		
		/// The position after the result match of the collection if the result match exists, otherwise an invalid index.
		case afterResultMatch
		
	}
	
	public var startIndex: Index {
		return .resultMatch
	}
	
	public var endIndex: Index {
		return resultMatch == nil ? .resultMatch : .afterResultMatch
	}
	
	public subscript (index: Index) -> Match<Subject> {
		switch index {
			
			case .resultMatch:
			guard let resultMatch = resultMatch else { preconditionFailure("Index out of bounds") }
			return resultMatch
			
			case .afterResultMatch:
			preconditionFailure("Index out of bounds")
			
		}
	}
	
	public func index(before index: Index) -> Index {
		switch index {
			case .resultMatch:		preconditionFailure("Index out of bounds")
			case .afterResultMatch:	return .resultMatch
		}
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			case .resultMatch:		return .afterResultMatch
			case .afterResultMatch:	preconditionFailure("Index out of bounds")
		}
	}
	
}

extension SingularMatchCollection.Index : Comparable {
	public static func < <Subject>(left: SingularMatchCollection<Subject>.Index, right: SingularMatchCollection<Subject>.Index) -> Bool {
		return (left, right) == (.resultMatch, .afterResultMatch)
	}
}
