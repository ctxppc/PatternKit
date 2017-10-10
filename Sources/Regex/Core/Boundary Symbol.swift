// PatternKit © 2017 Constantino Tsarouhas

/// A symbol that designates the leading or trailing edge of a bounded expression.
public protocol BoundarySymbolProtocol : SymbolProtocol {
	
	/// The leading and trailing boundaries.
	static var boundaries: (leading: Self, trailing: Self) { get }
	
}
