// PatternKit © 2017–19 Constantino Tsarouhas

import DepthKit
import PatternKitCore

/// A pattern that matches a set of same-typed patterns separately.
public struct HomogeneousAlternation<Subpattern : Pattern> {
	
	public typealias Subject = Subpattern.Subject
	
	/// Creates a homogeneous alternation pattern with given subpatterns.
	///
	/// - Parameter mainPattern: The main pattern.
	/// - Parameter otherPatterns: The alternative patterns.
	public init(_ mainPattern: Subpattern, _ otherPatterns: Subpattern...) {
		self.subpatterns = [mainPattern] + otherPatterns
	}
	
	/// Creates a homogeneous alternation pattern with given subpatterns.
	///
	/// - Requires: `subpatterns` contains at least two subpatterns.
	///
	/// - Parameter subpatterns: The subpatterns.
	public init(_ subpatterns: [Subpattern]) {
		precondition(subpatterns.count >= 2, "Fewer than 2 subpatterns in alternation")
		self.subpatterns = subpatterns
	}
	
	/// The subpatterns, in order of matching.
	///
	/// - Invariant: `subpatterns` contains at least two subpatterns.
	public var subpatterns: [Subpattern] {
		willSet {
			precondition(newValue.count >= 2, "Fewer than 2 subpatterns in alternation")
		}
	}
	
}

extension HomogeneousAlternation : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> ForwardHomogeneousAlternationMatchCollection<Subpattern> {
		return ForwardHomogeneousAlternationMatchCollection(subpatterns: subpatterns, baseMatch: base)
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> BackwardHomogeneousAlternationMatchCollection<Subpattern> {
		return BackwardHomogeneousAlternationMatchCollection(subpatterns: subpatterns, baseMatch: base)
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subpattern.Subject, fromIndex inputPosition: Subpattern.Subject.Index) -> Subpattern.Subject.Index {
		return subpatterns.map {
			$0.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition)
		}.min()!
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subpattern.Subject, fromIndex inputPosition: Subpattern.Subject.Index) -> Subpattern.Subject.Index {
		return subpatterns.map {
			$0.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition)
		}.max()!
	}
	
}
