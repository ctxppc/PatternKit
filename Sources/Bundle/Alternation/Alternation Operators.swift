// PatternKit © 2017–19 Constantino Tsarouhas

/// Returns an alternation between two arbitrary patterns.
///
/// - Parameter mainPattern: The pattern whose matches are generated first.
/// - Parameter alternativePattern: The pattern whose matches are generated after those of the main pattern.
///
/// - Returns: `Alternation(mainPattern, alternativePattern)`
public func | <L, R>(mainPattern: L, alternativePattern: R) -> Alternation<L, R> {
	return Alternation(mainPattern, alternativePattern)
}
