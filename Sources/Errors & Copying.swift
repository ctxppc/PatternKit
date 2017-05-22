// PatternKit © 2017 Constantino Tsarouhas

import Foundation

/// A value that represents an unimplemented code path.
///
/// Use of this value silences the compiler's definite initialisation analyser and causes a fatal error at runtime. For example, this does not produce a build-time error:
///
///		func doingSomething() -> Something {
///			unimplemented
///		}
var unimplemented: Never {
	fatalError("Unimplemented code path assertion failure")
}

/// A value that represents an impossible code path that cannot be statically handled by the compiler.
///
/// Use of this value silences the compiler's definite initialisation analyser and causes a fatal error at runtime. For example, this does not produce a build-time error:
///
///		func doingSomething(with value: Value) -> Something {
///			switch value {
///				case something:			return …
///				case somethingElse:		return …
///				default:				impossible
///			}
///		}
var impossible: Never {
	fatalError("Impossible code path assertion failure")
}

/// Returns a mutated copy of some value.
///
/// - Warning: This function is meant for use with non-object values; it mutates objects in-place.
///
/// - Parameters:
///		- subject: The value whose copy to mutate and return.
///		- mutator: A closure that performs mutation.
///
/// - Returns: A copy of `subject` after being mutated by `mutator`.
func withCopy<S>(of subject: S, mutator: (inout S) throws -> Any) rethrows -> S {
	var subject = subject
	_ = try mutator(&subject)
	return subject
}

/// Returns a mutated copy of some value.
///
/// - Warning: This function is meant for use with non-object values; it mutates objects in-place.
///
/// - Parameters:
///		- subject: The value whose copy to mutate and return.
///		- mutator: A closure that performs mutation.
///		- argument: The argument to the subject-qualified mutator.
///
/// - Returns: A copy of `subject` after being mutated by `mutator`.
func withCopy<S, A>(of subject: S, mutator: (inout S) throws -> (A) -> Any, argument: A) rethrows -> S {
	var subject = subject
	_ = try mutator(&subject)(argument)
	return subject
}

/// Returns a mutated copy of some value.
///
/// - Warning: This function is meant for use with non-object values; it mutates objects in-place.
///
/// - Parameters:
///		- subject: The value whose copy to mutate and return.
///		- mutator: A closure that performs mutation.
///		- firstArgument: The first argument to the subject-qualified mutator.
///		- secondArgument: The second argument to the subject-qualified mutator.
///
/// - Returns: A copy of `subject` after being mutated by `mutator`.
func withCopy<S, A, B>(of subject: S, mutator: (inout S) throws -> (A, B) -> Any, arguments firstArgument: A, _ secondArgument: B) rethrows -> S {
	var subject = subject
	_ = try mutator(&subject)(firstArgument, secondArgument)
	return subject
}

/// Returns a mutated copy of some value.
///
/// - Warning: This function is meant for use with non-object values; it mutates objects in-place.
///
/// - Parameters:
///		- subject: The value whose copy to mutate and return.
///		- mutator: A closure that performs mutation.
///		- firstArgument: The first argument to the subject-qualified mutator.
///		- secondArgument: The second argument to the subject-qualified mutator.
///		- thirdArgument: The third argument to the subject-qualified mutator.
///
/// - Returns: A copy of `subject` after being mutated by `mutator`.
func withCopy<S, A, B, C>(of subject: S, mutator: (inout S) throws -> (A, B, C) -> Any, arguments firstArgument: A, _ secondArgument: B, _ thirdArgument: C) rethrows -> S {
	var subject = subject
	_ = try mutator(&subject)(firstArgument, secondArgument, thirdArgument)
	return subject
}
