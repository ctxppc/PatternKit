// PatternKit © 2017–21 Constantino Tsarouhas

import DepthKit

public enum MultiplicityRange : Equatable {
	
	/// A closed range.
	///
	/// - Invariant: The lower bound is nonnegative.
	/// - Invariant: The upper bound is greater than zero if the lower bound is zero.
	///
	/// - Parameter 1: The closed range.
	case closed(ClosedRange<Int>)
	
	/// A partial, lower-bounded range.
	///
	/// - Invariant: The lower bound is nonnegative.
	///
	/// - Parameter 1: The partial range.
	case partial(PartialRangeFrom<Int>)
	
	internal var serialisation: String {
		precondition(lowerBound >= 0, "Negative multiplicity")
		switch self {
			case 0...1:										return "?"
			case 0...:										return "*"
			case 1...:										return "+"
			case .closed(let range) where range.count == 1:	return "{\(range.lowerBound)}"
			case .closed(let range):						return "{\(range.lowerBound),\(range.upperBound)}"
			case .partial(let range):						return "{\(range.lowerBound),}"
		}
	}
	
	/// The lower bound.
	public var lowerBound: Int {
		switch self {
			case .closed(let range):	return range.lowerBound
			case .partial(let range):	return range.lowerBound
		}
	}
	
	/// The upper bound, if any.
	public var upperBound: Int? {
		switch self {
			case .closed(let range):	return range.upperBound
			case .partial:				return nil
		}
	}
	
}

public func ... (lowerBound: Int, upperBound: Int) -> MultiplicityRange {
	return .closed(lowerBound...upperBound)
}

public postfix func ... (lowerBound: Int) -> MultiplicityRange {
	return .partial(lowerBound...)
}

extension PartialRangeFrom : Equatable {
	public static func == (firstRange: PartialRangeFrom, otherRange: PartialRangeFrom) -> Bool {
		return firstRange.lowerBound == otherRange.lowerBound
	}
}
