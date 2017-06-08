// PatternKit © 2017 Constantino Tsarouhas

public struct RepeatingMatchCollection<RepeatedPattern : Pattern> {
	
	// TODO
	
}

extension RepeatingMatchCollection : BidirectionalCollection {
	
	public enum Index {
		// TODO
	}
	
	public var startIndex: Index {
		unimplemented
	}
	
	public var endIndex: Index {
		unimplemented
	}
	
	public subscript (index: Index) -> Match<RepeatedPattern.Subject> {
		unimplemented
	}
	
	public func index(before index: Index) -> Index {
		unimplemented
	}
	
	public func index(after index: Index) -> Index {
		unimplemented
	}
	
}

extension RepeatingMatchCollection.Index : Comparable {
	
	public static func <(leftIndex: RepeatingMatchCollection<RepeatedPattern>.Index, rightIndex: RepeatingMatchCollection<RepeatedPattern>.Index) -> Bool {
		unimplemented
	}
	
	public static func ==(leftIndex: RepeatingMatchCollection<RepeatedPattern>.Index, rightIndex: RepeatingMatchCollection<RepeatedPattern>.Index) -> Bool {
		unimplemented
	}
	
}
