// PatternKit © 2017–19 Constantino Tsarouhas

import DepthKit
import PatternKitCore

/// A pattern that matches a series of same-typed patterns sequentially.
public struct HomogeneousConcatenation<Subpattern : Pattern> {
	
	public typealias Subject = Subpattern.Subject
	
	/// Creates a homogeneous concatenation pattern with given subpatterns.
	///
	/// - Parameter firstPattern: The first subpattern.
	/// - Parameter otherPatterns: The other subpatterns.
	public init(_ firstPattern: Subpattern, _ otherPatterns: Subpattern...) {
		self.subpatterns = [firstPattern] + otherPatterns
	}
	
	/// Creates a homogeneous concatenation pattern with given subpatterns.
	///
	/// - Requires: `subpatterns` contains at least two subpatterns.
	///
	/// - Parameter subpatterns: The subpatterns.
	public init(_ subpatterns: [Subpattern]) {
		precondition(subpatterns.count >= 2, "Fewer than 2 subpatterns in concatenation")
		self.subpatterns = subpatterns
	}
	
	/// The subpatterns, in order of matching.
	///
	/// - Invariant: `subpatterns` contains at least two subpatterns.
	public var subpatterns: [Subpattern] {
		willSet {
			precondition(newValue.count >= 2, "Fewer than 2 subpatterns in concatenation")
		}
	}
	
}

extension HomogeneousConcatenation : Pattern {
	
	public func forwardMatches(enteringFrom base: Match<Subject>) -> ForwardHomogeneousConcatenationMatchCollection<Subpattern> {
		return ForwardHomogeneousConcatenationMatchCollection(subpatterns: subpatterns, baseMatch: base)
	}
	
	public func backwardMatches(recedingFrom base: Match<Subject>) -> BackwardHomogeneousConcatenationMatchCollection<Subpattern> {
		return BackwardHomogeneousConcatenationMatchCollection(subpatterns: subpatterns, baseMatch: base)
	}
	
	public func underestimatedSmallestInputPositionForForwardMatching(on subject: Subpattern.Subject, fromIndex inputPosition: Subpattern.Subject.Index) -> Subpattern.Subject.Index {
		return subpatterns.first!.underestimatedSmallestInputPositionForForwardMatching(on: subject, fromIndex: inputPosition)
	}
	
	public func overestimatedLargestInputPositionForBackwardMatching(on subject: Subpattern.Subject, fromIndex inputPosition: Subpattern.Subject.Index) -> Subpattern.Subject.Index {
		return subpatterns.last!.overestimatedLargestInputPositionForBackwardMatching(on: subject, fromIndex: inputPosition)
	}
	
}
