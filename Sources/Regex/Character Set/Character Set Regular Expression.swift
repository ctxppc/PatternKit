// PatternKit © 2017 Constantino Tsarouhas

import DepthKit

/// A regular expression that expresses a character set.
public struct CharacterSetRegularExpression {
	
	/// Creates a character set regular expression with given members.
	///
	/// - Parameter members: The enumerated members of the character set. The default is the empty set.
	public init(_ members: [Member] = []) {
		self.members = members
	}
	
	/// The enumerated members of the character set.
	public var members: [Member]
	public enum Member {
		
		/// The member is a single scalar.
		///
		/// - Parameter 1: The Unicode scalar that is a member of the character set.
		case singletonScalar(UnicodeScalar)
		
		/// The member is an interval of scalars.
		///
		/// - Parameter 1: The closed range of Unicode scalars that are member of the character set.
		case interval(ClosedRange<UnicodeScalar>)
		
	}
	
	public enum Symbol {
		
		/// A symbol that represents the leading boundary of a character set.
		case leadingBoundary
		
		/// A symbol that represents a single scalar member in a character set.
		///
		/// - Parameter 1: The Unicode scalar that is a member of the character set.
		/// - Parameter firstInSet: Whether the scalar is the first member in the character set.
		case singletonScalar(UnicodeScalar, firstInSet: Bool)
		
		/// A symbol that represents a lower bound scalar of an interval.
		///
		/// - Parameter 1: The Unicode scalar at the lower bound of the interval.
		/// - Parameter firstInSet: Whether the interval is the first member in the character set.
		case intervalLowerBoundScalar(UnicodeScalar, firstInSet: Bool)
		
		/// A symbol that represents a delimiter between the lower bound and upper bound symbols in an interval.
		case intervalBoundsDelimiter
		
		/// A symbol that represents an upper bound scalar of an interval.
		///
		/// - Parameter 1: The Unicode scalar at the upper bound (inclusive) of the interval.
		case intervalUpperBoundScalar(UnicodeScalar)
		
		/// A symbol that represents the trailing boundary of a character set.
		case trailingBoundary
		
	}
	
}

extension CharacterSetRegularExpression : RegularExpression {
	
	public enum Index {
		
		/// The position to the leading boundary symbol.
		case leadingBoundary
		
		/// A position to a symbol representing a singleton scalar member.
		///
		/// - Parameter index: The index of the member.
		case singletonScalarMember(index: Int)
		
		/// A position to a symbol representing a lower bound scalar of an interval member.
		///
		/// - Parameter index: The index of the member.
		case intervalLowerBoundScalar(index: Int)
		
		/// A position to a symbol representing a delimiter between the lower bound and upper bound symbols in an interval member.
		///
		/// - Parameter index: The index of the member.
		case intervalBoundsDelimiter(index: Int)
		
		/// A position to a symbol representing an upper bound scalar of an interval member.
		///
		/// - Parameter index: The index of the member.
		case intervalUpperBoundScalar(index: Int)
		
		/// The position to the trailing boundary symbol.
		case trailingBoundary
		
		/// The position after the last symbol.
		case end
		
	}
	
	public var startIndex: Index {
		return .leadingBoundary
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> SymbolProtocol {
		switch index {
			
			case .leadingBoundary:
			return Symbol.leadingBoundary
			
			case .singletonScalarMember(index: let index):
			guard case .singletonScalar(let scalar) = members[index] else { fatalError("Incompatible member type of index") }
			return Symbol.singletonScalar(scalar, firstInSet: index == members.startIndex)
			
			case .intervalLowerBoundScalar(index: let index):
			guard case .interval(let range) = members[index] else { fatalError("Incompatible member type of index") }
			return Symbol.intervalLowerBoundScalar(range.lowerBound, firstInSet: index == members.startIndex)
			
			case .intervalBoundsDelimiter:
			return Symbol.intervalBoundsDelimiter
			
			case .intervalUpperBoundScalar(index: let index):
			guard case .interval(let range) = members[index] else { fatalError("Incompatible member type of index") }
			return Symbol.intervalUpperBoundScalar(range.lowerBound)
			
			case .trailingBoundary:
			return Symbol.trailingBoundary
			
			case .end:
			indexOutOfBounds
			
		}
	}
	
	public func index(before index: Index) -> Index {
		switch index {
			
			case .leadingBoundary:
			indexOutOfBounds
			
			case .singletonScalarMember(index: let index):
			guard index > members.startIndex else { return .leadingBoundary }
			return indexForMember(at: members.index(before: index), boundary: .trailing)
			
			case .intervalLowerBoundScalar(index: let index):
			guard index > members.startIndex else { return .leadingBoundary }
			return indexForMember(at: members.index(before: index), boundary: .trailing)
			
			case .intervalBoundsDelimiter(index: let index):
			return .intervalLowerBoundScalar(index: index)
			
			case .intervalUpperBoundScalar(index: let index):
			return .intervalBoundsDelimiter(index: index)
			
			case .trailingBoundary:
			let index = members.endIndex
			guard index > members.startIndex else { return .leadingBoundary }
			return indexForMember(at: members.index(before: index), boundary: .trailing)
			
			case .end:
			return .trailingBoundary
			
		}
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			
			case .leadingBoundary:
			guard !members.isEmpty else { return .trailingBoundary }
			return indexForMember(at: members.startIndex, boundary: .leading)
			
			case .singletonScalarMember(index: let index):
			let nextIndex = members.index(after: index)
			guard nextIndex < members.endIndex else { return .trailingBoundary }
			return indexForMember(at: nextIndex, boundary: .leading)
			
			case .intervalLowerBoundScalar(index: let index):
			return .intervalBoundsDelimiter(index: index)
			
			case .intervalBoundsDelimiter(index: let index):
			return .intervalUpperBoundScalar(index: index)
			
			case .intervalUpperBoundScalar(index: let index):
			let nextIndex = members.index(after: index)
			guard nextIndex < members.endIndex else { return .trailingBoundary }
			return indexForMember(at: nextIndex, boundary: .leading)
			
			case .trailingBoundary:
			return .end
			
			case .end:
			indexOutOfBounds
			
		}
	}
	
	private enum Boundary {
		case leading
		case trailing
	}
	
	private func indexForMember(at index: Int, boundary: Boundary) -> Index {
		switch (members[index], boundary) {
		
			case (.singletonScalar, _):
			return .singletonScalarMember(index: index)
			
			case (.interval, .leading):
			return .intervalLowerBoundScalar(index: index)
			
			case (.interval, .trailing):
			return .intervalUpperBoundScalar(index: index)
			
		}
	}
	
	
}

extension CharacterSetRegularExpression.Symbol : SymbolProtocol {
	
	public func serialisation(language: Language) throws -> String {
		TODO.unimplemented
	}
	
}

extension CharacterSetRegularExpression.Index : Comparable {
	
	public static func <(smallerIndex: CharacterSetRegularExpression.Index, greaterIndex: CharacterSetRegularExpression.Index) -> Bool {
		
		enum SimpleIndex : Int {
			
			case leadingBoundary
			case singletonScalarMember
			case intervalLowerBoundScalar
			case intervalBoundsDelimiter
			case intervalUpperBoundScalar
			case trailingBoundary
			case end
			
			init(_ index: CharacterSetRegularExpression.Index) {
				switch index {
					case .leadingBoundary:			self = .leadingBoundary
					case .singletonScalarMember:	self = .singletonScalarMember
					case .intervalLowerBoundScalar:	self = .intervalLowerBoundScalar
					case .intervalBoundsDelimiter:	self = .intervalBoundsDelimiter
					case .intervalUpperBoundScalar:	self = .intervalUpperBoundScalar
					case .trailingBoundary:			self = .trailingBoundary
					case .end:						self = .end
				}
			}
			
		}
		
		func memberIndex(of index: CharacterSetRegularExpression.Index) -> Int? {
			switch index {
				case .singletonScalarMember(index: let index):		return index
				case .intervalLowerBoundScalar(index: let index):	return index
				case .intervalBoundsDelimiter(index: let index):	return index
				case .intervalUpperBoundScalar(index: let index):	return index
				default:											return nil
			}
		}
		
		if let memberIndexOfSmallerIndex = memberIndex(of: smallerIndex), let memberIndexOfGreaterIndex = memberIndex(of: greaterIndex) {
			if memberIndexOfSmallerIndex < memberIndexOfGreaterIndex {
				return true
			} else if memberIndexOfSmallerIndex > memberIndexOfGreaterIndex {
				return false
			} else {
				return SimpleIndex(smallerIndex).rawValue < SimpleIndex(greaterIndex).rawValue
			}
		} else {
			return SimpleIndex(smallerIndex).rawValue < SimpleIndex(greaterIndex).rawValue
		}
		
	}
	
	public static func ==(firstIndex: CharacterSetRegularExpression.Index, otherIndex: CharacterSetRegularExpression.Index) -> Bool {
		switch (firstIndex, otherIndex) {
			case (.leadingBoundary, .leadingBoundary):																	return true
			case (.singletonScalarMember(index: let firstIndex), .singletonScalarMember(index: let otherIndex)):		return firstIndex == otherIndex
			case (.intervalLowerBoundScalar(index: let firstIndex), .intervalLowerBoundScalar(index: let otherIndex)):	return firstIndex == otherIndex
			case (.intervalBoundsDelimiter(index: let firstIndex), .intervalBoundsDelimiter(index: let otherIndex)):	return firstIndex == otherIndex
			case (.intervalUpperBoundScalar(index: let firstIndex), .intervalUpperBoundScalar(index: let otherIndex)):	return firstIndex == otherIndex
			case (.trailingBoundary, .trailingBoundary):																return true
			case (.end, .end):																							return true
			default:																									return false
		}
	}
	
}
