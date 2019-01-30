// PatternKit © 2017–19 Constantino Tsarouhas

public enum NoncapturingGroupBoundarySymbol : BoundarySymbolProtocol {
	
	/// The leading boundary.
	case leadingBoundary
	
	/// The trailing boundary.
	case trailingBoundary
	
	// See protocol.
	public static var boundaries: (leading: NoncapturingGroupBoundarySymbol, trailing: NoncapturingGroupBoundarySymbol) {
		return (.leadingBoundary, .trailingBoundary)
	}
	
	// See protocol.
	public func serialisation(language: Language) -> String {
		switch self {
			case .leadingBoundary:	return "(?:"
			case .trailingBoundary:	return ")"
		}
	}
	
}
