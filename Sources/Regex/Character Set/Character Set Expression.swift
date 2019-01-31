// PatternKit © 2017–19 Constantino Tsarouhas

import DepthKit

/// An expression that expresses a character set.
public struct CharacterSetExpression {
	
	/// Creates a character set expression with given members.
	///
	/// - Parameter members: The enumerated members of the character set. The default is the empty set.
	/// - Parameter membership: Whether the set's members are considered positive or negative matches.
	public init(_ members: [Member] = [], membership: Membership = .inclusive) {
		self.members = members
		self.membership = membership
	}
	
	/// Whether the set's members are considered positive or negative matches.
	public var membership: Membership
	public enum Membership {
		
		/// The set's enumerated members are considered positive matches.
		case inclusive
		
		/// The set's enumerated members are considered negative matches.
		case exclusive
		
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
		///
		/// - Parameter membership: Whether the set's members are considered positive or negative matches.
		case leadingBoundary(membership: Membership)
		
		/// A symbol that represents a single scalar member in a character set.
		///
		/// - Parameter 1: The Unicode scalar that is a member of the character set.
		/// - Parameter firstInSet: Whether the scalar is the first member in the character set.
		/// - Parameter membership: Whether the set's members are considered positive or negative matches.
		case singletonScalar(UnicodeScalar, firstInSet: Bool, membership: Membership)
		
		/// A symbol that represents a lower bound scalar of an interval.
		///
		/// - Parameter 1: The Unicode scalar at the lower bound of the interval.
		/// - Parameter firstInSet: Whether the interval is the first member in the character set.
		/// - Parameter membership: Whether the set's members are considered positive or negative matches.
		case intervalLowerBoundScalar(UnicodeScalar, firstInSet: Bool, membership: Membership)
		
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

extension CharacterSetExpression : Expression {
	
	public enum Index : Equatable {
		
		/// The position of the leading boundary symbol.
		case leadingBoundary
		
		/// A position of a symbol representing a singleton scalar member.
		///
		/// - Invariant: `index` is an index to a singleton scalar member in the character set.
		///
		/// - Parameter index: The index of the member.
		case singletonScalarMember(index: Int)
		
		/// A position of a symbol representing a lower bound scalar of an interval member.
		///
		/// - Invariant: `index` is an index to an interval member in the character set.
		///
		/// - Parameter index: The index of the member.
		case intervalLowerBoundScalar(index: Int)
		
		/// A position of a symbol representing a delimiter between the lower bound and upper bound symbols in an interval member.
		///
		/// - Invariant: `index` is an index to an interval member in the character set.
		///
		/// - Parameter index: The index of the member.
		case intervalBoundsDelimiter(index: Int)
		
		/// A position of a symbol representing an upper bound scalar of an interval member.
		///
		/// - Invariant: `index` is an index to an interval member in the character set.
		///
		/// - Parameter index: The index of the member.
		case intervalUpperBoundScalar(index: Int)
		
		/// The position of the trailing boundary symbol.
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
			return Symbol.leadingBoundary(membership: membership)
			
			case .singletonScalarMember(index: let index):
			guard case .singletonScalar(let scalar) = members[index] else { fatalError("Incompatible member type of index") }
			return Symbol.singletonScalar(scalar, firstInSet: index == members.startIndex, membership: membership)
			
			case .intervalLowerBoundScalar(index: let index):
			guard case .interval(let range) = members[index] else { fatalError("Incompatible member type of index") }
			return Symbol.intervalLowerBoundScalar(range.lowerBound, firstInSet: index == members.startIndex, membership: membership)
			
			case .intervalBoundsDelimiter:
			return Symbol.intervalBoundsDelimiter
			
			case .intervalUpperBoundScalar(index: let index):
			guard case .interval(let range) = members[index] else { fatalError("Incompatible member type of index") }
			return Symbol.intervalUpperBoundScalar(range.upperBound)
			
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
	
	public var bindingClass: BindingClass {
		return .atomic
	}
	
}

extension CharacterSetExpression.Member : ExpressibleByUnicodeScalarLiteral {
	public init(unicodeScalarLiteral value: UnicodeScalar) {
		self = .singletonScalar(value)
	}
}

public func ...(lowerBound: UnicodeScalar, upperBound: UnicodeScalar) -> CharacterSetExpression.Member {
	return .interval(lowerBound...upperBound)
}

extension CharacterSetExpression.Symbol : SymbolProtocol {
	
	public func serialisation(language: Language) -> String {
		
		func serialiseScalar(_ scalar: UnicodeScalar, firstInSet: Bool, membership: CharacterSetExpression.Membership) -> String {
			switch (scalar, firstInSet, membership) {
				case ("^", true, .inclusive):	return "\\^"
				case ("-", false, _):			return "\\-"
				case ("\\", _, _):				return "\\\\"
				case ("]", _, _):				return "\\]"
				case ("\u{8}", _, _):			return "\\b"
				default:						return serialiseGeneralScalar(scalar, language: language)
			}
		}
		
		switch self {
			case .leadingBoundary(membership: let membership):													return membership == .inclusive ? "[" : "[^"
			case .singletonScalar(let scalar, firstInSet: let firstInSet, membership: let membership):			return serialiseScalar(scalar, firstInSet: firstInSet, membership: membership)
			case .intervalLowerBoundScalar(let scalar, firstInSet: let firstInSet, membership: let membership):	return serialiseScalar(scalar, firstInSet: firstInSet, membership: membership)
			case .intervalBoundsDelimiter:																		return "-"
			case .intervalUpperBoundScalar("\\"):																return "\\\\"
			case .intervalUpperBoundScalar("]"):																return "\\]"
			case .intervalUpperBoundScalar(let scalar):															return String(scalar)
			case .trailingBoundary:																				return "]"
		}
		
	}
	
}

extension CharacterSetExpression.Index : Comparable {
	public static func < (smallerIndex: CharacterSetExpression.Index, greaterIndex: CharacterSetExpression.Index) -> Bool {
		
		enum SimpleIndex : Int {
			
			case leadingBoundary
			case singletonScalarMember
			case intervalLowerBoundScalar
			case intervalBoundsDelimiter
			case intervalUpperBoundScalar
			case trailingBoundary
			case end
			
			init(_ index: CharacterSetExpression.Index) {
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
		
		func memberIndex(of index: CharacterSetExpression.Index) -> Int? {
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
}
