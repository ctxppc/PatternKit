// PatternKit © 2017 Constantino Tsarouhas

import DepthKit

/// A regular expression that expresses an alternation pattern.
public struct AlternationRegularExpression<MainExpression : RegularExpression, AlternativeExpression : RegularExpression> where
	MainExpression.Indices : BidirectionalCollection,
	AlternativeExpression.Indices : BidirectionalCollection {
	
	/// Creates an alternation regular expression with given subexpressions.
	///
	/// - Parameter mainExpression: The expression that represents the main pattern of the alternation.
	/// - Parameter alternativeExpression: The expression that represents the alternative pattern of the alternation.
	public init(_ mainExpression: MainExpression, _ alternativeExpression: AlternativeExpression) {
		self.mainExpression = mainExpression
		self.alternativeExpression = alternativeExpression
	}
	
	/// The expression that represents the main pattern of the alternation.
	public var mainExpression: MainExpression
	
	/// The expression that represents the alternative pattern of the alternation.
	public var alternativeExpression: AlternativeExpression
	
}

extension AlternationRegularExpression : RegularExpression {
	
	public enum Index {
		
		/// A position to a symbol in the main expression.
		///
		/// - Parameter innerIndex: The position of the symbol within the main expression.
		case inMainExpression(innerIndex: MainExpression.Index)
		
		/// The position to the delimiter symbol.
		case delimiter
		
		/// A position to a symbol in the alternative expression.
		///
		/// - Parameter innerIndex: The position of the symbol within the alternative expression.
		case inAlternativeExpression(innerIndex: AlternativeExpression.Index)
		
		/// The position after the last symbol.
		case end
		
	}
	
	public var startIndex: Index {
		if let firstIndex = mainExpression.indices.first {
			return .inMainExpression(innerIndex: firstIndex)
		} else {
			return .delimiter
		}
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> SymbolProtocol {
		switch index {
			case .inMainExpression(innerIndex: let index):			return mainExpression[index]
			case .delimiter:										return AlternationDelimiterSymbol()
			case .inAlternativeExpression(innerIndex: let index):	return alternativeExpression[index]
			case .end:												indexOutOfBounds
		}
	}
	
	public func index(before index: Index) -> Index {
		switch index {
			
			case .inMainExpression(innerIndex: let index):
			return .inMainExpression(innerIndex: mainExpression.index(before: index))
			
			case .delimiter:
			guard let lastIndex = mainExpression.indices.last else { indexOutOfBounds }
			return .inMainExpression(innerIndex: lastIndex)
			
			case .inAlternativeExpression(innerIndex: let index):
			guard index > alternativeExpression.startIndex else { return .delimiter }
			return .inAlternativeExpression(innerIndex: alternativeExpression.index(before: index))
			
			case .end:
			guard let lastIndex = alternativeExpression.indices.last else { return .delimiter }
			return .inAlternativeExpression(innerIndex: lastIndex)
			
		}
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			
			case .inMainExpression(innerIndex: let index):
			let nextIndex = mainExpression.index(after: index)
			guard nextIndex < mainExpression.endIndex else { return .delimiter }
			return .inMainExpression(innerIndex: nextIndex)
			
			case .delimiter:
			guard let firstIndex = alternativeExpression.indices.first else { indexOutOfBounds }
			return .inAlternativeExpression(innerIndex: firstIndex)
			
			case .inAlternativeExpression(innerIndex: let index):
			let nextIndex = alternativeExpression.index(after: index)
			guard nextIndex < alternativeExpression.endIndex else { indexOutOfBounds }
			return .inAlternativeExpression(innerIndex: nextIndex)
			
			case .end:
			indexOutOfBounds
			
		}
	}
	
}

extension AlternationRegularExpression.Index : Comparable {
	
	public static func <(smallerIndex: AlternationRegularExpression.Index, greaterIndex: AlternationRegularExpression.Index) -> Bool {
		switch (smallerIndex, greaterIndex) {
			case (.inMainExpression(innerIndex: let smallerIndex), .inMainExpression(innerIndex: let greaterIndex)):				return smallerIndex < greaterIndex
			case (.inMainExpression, _):																							return true
			case (.delimiter, .inMainExpression):																					return false
			case (.delimiter, .delimiter):																							return false
			case (.delimiter, _):																									return true
			case (.inAlternativeExpression, .inMainExpression):																		return false
			case (.inAlternativeExpression, .delimiter):																			return false
			case (.inAlternativeExpression(innerIndex: let smallerIndex), .inAlternativeExpression(innerIndex: let greaterIndex)):	return smallerIndex < greaterIndex
			case (.inAlternativeExpression, .end):																					return true
			case (.end, _):																											return false
		}
	}
	
	public static func ==(firstIndex: AlternationRegularExpression.Index, otherIndex: AlternationRegularExpression.Index) -> Bool {
		switch (firstIndex, otherIndex) {
			case (.inMainExpression(innerIndex: let firstIndex), .inMainExpression(innerIndex: let otherIndex)):				return firstIndex == otherIndex
			case (.delimiter, .delimiter):																						return true
			case (.inAlternativeExpression(innerIndex: let firstIndex), .inAlternativeExpression(innerIndex: let otherIndex)):	return firstIndex == otherIndex
			case (.end, .end):																									return true
			default:																											return false
		}
	}
	
}

/// A symbol that separates the different subexpressions in an alternation.
public struct AlternationDelimiterSymbol : SymbolProtocol {
	
	// See protocol.
	public func serialisation(language: Language) -> String {
		return "|"
	}
	
}
