// PatternKit © 2017 Constantino Tsarouhas

import DepthKit
import PatternKitCore

/// A collection of forward matches of a homogeneous alternation pattern.
public struct ForwardHomogeneousAlternationMatchCollection<Subpattern : Pattern> {
	
	public typealias Subject = Subpattern.Subject
	
	/// Creates a homogeneous alternation match collection.
	///
	/// - Parameter subpatterns: The subpatterns.
	/// - Parameter baseMatch: The base match.
	internal init(subpatterns: [Subpattern], baseMatch: Match<Subject>) {
		assert(subpatterns.count >= 2)
		self.subpatterns = subpatterns
		self.baseMatch = baseMatch
	}
	
	/// The subpatterns of the alternation.
	///
	/// - Invariant: `subpatterns` contains at least two subpatterns.
	public let subpatterns: [Subpattern]
	
	/// The base match.
	public let baseMatch: Match<Subject>
	
}

extension ForwardHomogeneousAlternationMatchCollection : BidirectionalCollection {
	
	public enum Index {
		
		/// A position to a valid match.
		///
		/// - Invariant: No index in `indicesBySubpattern` is not equal to `endIndex` of their respective subpattern's match collection.
		///
		/// - Parameter indicesBySubpattern: The index within the leading pattern's match collection.
		case some(indicesBySubpattern: [Subpattern.ForwardMatchCollection.Index])
		
		/// The position after the last element of the match collection.
		case end
		
	}
	
	public var startIndex: Index {
		unimplemented
	}
	
	public var endIndex: Index {
		unimplemented
	}
	
	public subscript (index: Index) -> Match<Subject> {
		unimplemented
	}
	
	public func index(before index: Index) -> Index {
		unimplemented
	}
	
	public func index(after index: Index) -> Index {
		unimplemented
	}
	
}

extension ForwardHomogeneousAlternationMatchCollection.Index : Comparable {
	
	public static func <(lhs: ForwardHomogeneousAlternationMatchCollection.Index, rhs: ForwardHomogeneousAlternationMatchCollection.Index) -> Bool {
		unimplemented
	}
	
	public static func ==(lhs: ForwardHomogeneousAlternationMatchCollection.Index, rhs: ForwardHomogeneousAlternationMatchCollection.Index) -> Bool {
		unimplemented
	}
	
}
