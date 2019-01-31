// PatternKit © 2017–19 Constantino Tsarouhas

public enum NoncapturingGroupBoundarySymbol : SymbolProtocol {
	
	/// The leading boundary symbol.
	case leading
	
	/// The trailing boundary symbol.
	case trailing
	
	// See protocol.
	public func serialisation(language: Language) -> String {
		switch self {
			case .leading:	return "(?:"
			case .trailing:	return ")"
		}
	}
	
}
