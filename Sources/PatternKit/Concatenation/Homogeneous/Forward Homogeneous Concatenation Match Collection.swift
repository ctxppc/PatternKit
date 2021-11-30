// PatternKit © 2017–21 Constantino Tsarouhas

import DepthKit
import PatternKitCore

/// A collection of forward matches of a homogeneous concatenation pattern.
public struct ForwardHomogeneousConcatenationMatchCollection<Subpattern : Pattern> {
	
	public typealias Subject = Subpattern.Subject
	
	/// Creates a homogeneous concatenation match collection.
	///
	/// - Parameter subpatterns: The subpatterns.
	/// - Parameter baseMatch: The base match.
	internal init(subpatterns: [Subpattern], baseMatch: Match<Subject>) {
		assert(subpatterns.count >= 2)
		self.subpatterns = subpatterns
		self.baseMatch = baseMatch
	}
	
	/// The subpatterns of the concatenation.
	///
	/// - Invariant: `subpatterns` contains at least two subpatterns.
	public let subpatterns: [Subpattern]
	
	/// The base match.
	public let baseMatch: Match<Subject>
	
}

extension ForwardHomogeneousConcatenationMatchCollection : BidirectionalCollection {
	
	public enum Index : Equatable {
		
		/// A position to a valid match.
		///
		/// - Invariant: No index in `indicesBySubpattern` is not equal to `endIndex` of their respective subpattern's match collection.
		/// - Invariant: The number of indices is equal to the number of subpatterns.
		///
		/// - Parameter indicesBySubpattern: The indices within the respective subpatterns.
		case some(indicesBySubpattern: [Subpattern.ForwardMatchCollection.Index])
		
		/// The position after the last element of the match collection.
		case end
		
	}
	
	public var startIndex: Index {
		TODO.unimplemented
	}
	
	public var endIndex: Index {
		TODO.unimplemented
	}
	
	public subscript (index: Index) -> Match<Subject> {
		TODO.unimplemented
	}
	
	public func index(before index: Index) -> Index {
		TODO.unimplemented
	}
	
	public func index(after index: Index) -> Index {
		TODO.unimplemented
	}
	
}

extension ForwardHomogeneousConcatenationMatchCollection.Index : Comparable {
	public static func < (lhs: ForwardHomogeneousConcatenationMatchCollection.Index, rhs: ForwardHomogeneousConcatenationMatchCollection.Index) -> Bool {
		TODO.unimplemented
	}
}
