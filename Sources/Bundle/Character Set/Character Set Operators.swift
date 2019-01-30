// PatternKit © 2017–19 Constantino Tsarouhas

import Foundation
import DepthKit

/// Returns a character set containing a range of Unicode scalars.
///
/// - Parameter firstScalar: The first scalar in the range.
/// - Parameter lastScalar: The last scalar in the range, inclusive.
///
/// - Returns: `CharacterSet(charactersIn: firstScalar...lastScalar)`
public func ...(firstScalar: UnicodeScalar, lastScalar: UnicodeScalar) -> CharacterSet {
	return CharacterSet(charactersIn: firstScalar...lastScalar)
}

/// Returns the union of two character sets.
///
/// - Parameter firstSet: The first set.
/// - Parameter secondSet: The second set.
///
/// - Returns: `firstSet.union(secondSet)`
public func |(firstSet: CharacterSet, secondSet: CharacterSet) -> CharacterSet {
	return firstSet.union(secondSet)
}

/// Returns the union of a character set with a Unicode scalar.
///
/// - Parameter set: The set.
/// - Parameter scalar: The scalar.
///
/// - Returns: A superset of `set` such that `set.contains(scalar)`.
public func |(set: CharacterSet, scalar: UnicodeScalar) -> CharacterSet {
	var set = set
	set.insert(scalar)
	return set
}

/// Returns the union of a character set with a Unicode scalar.
///
/// - Parameter scalar: The scalar.
/// - Parameter set: The set.
///
/// - Returns: A superset of `set` such that `set.contains(scalar)`.
public func |(scalar: UnicodeScalar, set: CharacterSet) -> CharacterSet {
	var set = set
	set.insert(scalar)
	return set
}

/// Returns a character set containing two Unicode scalars.
///
/// - Parameter firstScalar: The first scalar.
/// - Parameter secondScalar: The second scalar.
///
/// - Returns: `CharacterSet([firstScalar, secondScalar])`
public func |(firstScalar: UnicodeScalar, secondScalar: UnicodeScalar) -> CharacterSet {
	return CharacterSet([firstScalar, secondScalar])
}
