// PatternKit © 2017–19 Constantino Tsarouhas

import DepthKit

/// An expression that expresses a homogeneous alternation pattern.
public struct HomogeneousAlternationExpression<Subexpression : Expression> {
	
	/// Creates a homogeneous concatenated expression with given subexpressions.
	///
	/// - Parameter firstExpression: The first subexpression.
	/// - Parameter otherExpressions: The other subexpressions.
	public init(_ firstExpression: Subexpression, _ otherExpressions: Subexpression...) {
		self.subexpressions = [firstExpression] + otherExpressions
	}
	
	/// Creates a homogeneous concatenated expression with given subexpressions.
	///
	/// - Requires: `subexpressions` contains at least two subexpressions.
	///
	/// - Parameter subexpressions: The subexpressions.
	public init(_ subexpressions: [Subexpression]) {
		precondition(subexpressions.count >= 2, "Fewer than 2 subexpressions in alternation")
		self.subexpressions = subexpressions
	}
	
	/// The subexpressions.
	///
	/// - Invariant: `subexpressions` contains at least two subexpressions.
	public var subexpressions: [Subexpression] {
		willSet {
			precondition(newValue.count >= 2, "Fewer than 2 subexpressions in alternation")
		}
	}
	
}

extension HomogeneousAlternationExpression : Expression {
	
	public enum Index : Equatable {
		
		/// A position of a symbol in a subexpression.
		///
		/// - Invariant: `subexpressionIndex` is an index to a subexpression.
		/// - Invariant: `innerIndex` is an index to a symbol in the subexpression.
		///
		/// - Parameter subexpressionIndex: The position of the subexpression.
		/// - Parameter innerIndex: The position of the symbol within the subexpression.
		case inSubexpression(subexpressionIndex: Int, innerIndex: Subexpression.Index)
		
		/// A position of a delimiter symbol.
		///
		/// - Invariant: `indexOfPreviousSubexpression` is an index to a subexpression that is not the last subexpression of the alternation expression.
		///
		/// - Parameter indexOfPreviousSubexpression: The position of the subexpression preceding the delimiter.
		case delimiter(indexOfPreviousSubexpression: Int)
		
		/// The position after the last symbol.
		case end
		
	}
	
	public var startIndex: Index {
		let firstSubexpressionIndex = subexpressions.indices.first !! "There are always at least two subexpressions"
		if let firstIndex = subexpressions[firstSubexpressionIndex].indices.first {
			return .inSubexpression(subexpressionIndex: firstSubexpressionIndex, innerIndex: firstIndex)
		} else {
			return .delimiter(indexOfPreviousSubexpression: firstSubexpressionIndex)
		}
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> SymbolProtocol {
		switch index {
			
			case .inSubexpression(subexpressionIndex: let subexpressionIndex, innerIndex: let innerIndex):
			return subexpressions[subexpressionIndex][innerIndex]
			
			case .delimiter:
			return AlternationDelimiterSymbol()
			
			case .end:
			indexOutOfBounds
			
		}
	}
	
	public func index(before index: Index) -> Index {
		
		// Returns the index with the last inner index in the subexpression at given index, or failing that, the index of the delimiter following the subexpression preceding the one at given index.
		func lastIndexInSubexpression(at subexpressionIndex: Int) -> Index {
			let subexpression = subexpressions[subexpressionIndex]
			if let lastInnerIndex = subexpression.indices.last {
				return .inSubexpression(subexpressionIndex: subexpressionIndex, innerIndex: lastInnerIndex)
			} else {
				return .delimiter(indexOfPreviousSubexpression: subexpressions.index(before: subexpressionIndex))
			}
		}
		
		switch index {
			
			case .inSubexpression(subexpressionIndex: let subexpressionIndex, innerIndex: let innerIndex):
			let subexpression = subexpressions[subexpressionIndex]
			if innerIndex > subexpression.startIndex {
				return .inSubexpression(subexpressionIndex: subexpressionIndex, innerIndex: subexpression.index(before: innerIndex))
			} else {
				return lastIndexInSubexpression(at: subexpressions.index(before: subexpressionIndex))
			}
			
			case .delimiter(indexOfPreviousSubexpression: let subexpressionIndex):
			return lastIndexInSubexpression(at: subexpressionIndex)
			
			case .end:
			return lastIndexInSubexpression(at: subexpressions.indices.last !! "There are always at least two subexpressions")
			
		}
		
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			
			case .inSubexpression(subexpressionIndex: let subexpressionIndex, innerIndex: let innerIndex):
			let subexpression = subexpressions[subexpressionIndex]
			let nextInnerIndex = subexpression.index(after: innerIndex)
			if nextInnerIndex < subexpression.endIndex {
				return .inSubexpression(subexpressionIndex: subexpressionIndex, innerIndex: nextInnerIndex)
			} else if subexpressions.indices.dropLast().contains(subexpressionIndex) {
				return .delimiter(indexOfPreviousSubexpression: subexpressionIndex)
			} else {
				return .end
			}
			
			case .delimiter(indexOfPreviousSubexpression: let previousSubexpressionIndex):
			let subexpressionIndex = subexpressions.index(after: previousSubexpressionIndex)	// never end index because no delimiter follows the last subexpression
			if let firstInnerIndex = subexpressions[subexpressionIndex].indices.first {
				return .inSubexpression(subexpressionIndex: subexpressionIndex, innerIndex: firstInnerIndex)
			} else {
				guard subexpressions.indices.dropLast().contains(subexpressionIndex) else { return .end }	// exclude last
				return .delimiter(indexOfPreviousSubexpression: subexpressionIndex)
			}
			
			case .end:
			indexOutOfBounds
			
		}
	}
	
	public var bindingClass: BindingClass {
		return .alternation
	}
	
}

extension HomogeneousAlternationExpression.Index : Comparable {
	public static func < (smallerIndex: HomogeneousAlternationExpression.Index, greaterIndex: HomogeneousAlternationExpression.Index) -> Bool {
		switch (smallerIndex, greaterIndex) {
			
			case (.inSubexpression(subexpressionIndex: let smallerSubexpressionIndex, innerIndex: let smallerInnerIndex), .inSubexpression(subexpressionIndex: let greaterSubexpressionIndex, innerIndex: let greaterInnerIndex)):
			return (smallerSubexpressionIndex, smallerInnerIndex) < (greaterSubexpressionIndex, greaterInnerIndex)
			
			case (.inSubexpression(subexpressionIndex: let subexpressionIndex, innerIndex: _), .delimiter(indexOfPreviousSubexpression: let delimiterIndex)):
			return subexpressionIndex <= delimiterIndex
			
			case (.inSubexpression, .end):
			return true
			
			case (.delimiter(indexOfPreviousSubexpression: let delimiterIndex), .inSubexpression(subexpressionIndex: let subexpressionIndex, innerIndex: _)):
			return subexpressionIndex >= delimiterIndex
			
			case (.delimiter(indexOfPreviousSubexpression: let smallerIndex), .delimiter(indexOfPreviousSubexpression: let greaterIndex)):
			return smallerIndex < greaterIndex
			
			case (.delimiter, .end):
			return true
			
			case (.end, _):
			return false
			
		}
	}
}
