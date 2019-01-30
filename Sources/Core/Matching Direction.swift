// PatternKit © 2017–19 Constantino Tsarouhas

/// A direction of matching.
public enum MatchingDirection {
	
	/// Elements in a collection are matched from low to high indices.
	case forward
	
	/// Elements in a collection are matched from high to low indices.
	case backward
	
	/// The inverse direction.
	public var inverse: MatchingDirection {
		switch self {
			case .forward:	return .backward
			case .backward:	return .forward
		}
	}
	
}

