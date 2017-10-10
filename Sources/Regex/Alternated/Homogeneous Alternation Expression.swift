// PatternKit © 2017 Constantino Tsarouhas

import DepthKit

/// An expression that expresses a homogeneous alternation pattern.
public struct HomogeneousAlternationExpression<Subexpression : Expression> where Subexpression.Indices : BidirectionalCollection {
	
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
	
	public enum Index {
		
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
		/// - Invariant: `indexOfPreviousSubexpression` is an index to a subexpression.
		///
		/// - Parameter indexOfPreviousSubexpression: The position of the subexpression preceding the delimiter.
		case delimiter(indexOfPreviousSubexpression: Int)
		
		/// The position after the last symbol.
		case end
		
	}
	
	public var startIndex: Index {
		if let firstIndex = subexpressions.first!.indices.first {
			return .inSubexpression(subexpressionIndex: subexpressions.indices.first!, innerIndex: firstIndex)
		} else {
			return .delimiter(indexOfPreviousSubexpression: subexpressions.indices.first!)
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
		
		func lastIndexInSubexpression(at subexpressionIndex: Int) -> Index {
			let subexpression = subexpressions[subexpressionIndex]
			if let lastInnerIndex = subexpression.indices.last {
				return .inSubexpression(subexpressionIndex: subexpressionIndex, innerIndex: lastInnerIndex)
			} else {
				return .delimiter(indexOfPreviousSubexpression: subexpressionIndex)
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
			return lastIndexInSubexpression(at: subexpressions.indices.last!)
			
		}
		
	}
	
	public func index(after index: Index) -> Index {
		switch index {
			
			case .inSubexpression(subexpressionIndex: let subexpressionIndex, innerIndex: let innerIndex):
			let subexpression = subexpressions[subexpressionIndex]
			let nextInnerIndex = subexpression.index(after: innerIndex)
			if nextInnerIndex < subexpression.endIndex {
				return .inSubexpression(subexpressionIndex: subexpressionIndex, innerIndex: nextInnerIndex)
			} else {
				return .delimiter(indexOfPreviousSubexpression: subexpressionIndex)
			}
			
			case .delimiter(indexOfPreviousSubexpression: let previousSubexpressionIndex):
			let subexpressionIndex = subexpressions.index(after: previousSubexpressionIndex)
			guard subexpressionIndex < subexpressions.endIndex else { return .end }
			if let firstInnerIndex = subexpressions[subexpressionIndex].indices.first {
				return .inSubexpression(subexpressionIndex: subexpressionIndex, innerIndex: firstInnerIndex)
			} else {
				let nextSubexpressionIndex = subexpressions.index(after: subexpressionIndex)
				guard nextSubexpressionIndex < subexpressions.endIndex else { return .end }
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
	
	public static func <(smallerIndex: HomogeneousAlternationExpression.Index, greaterIndex: HomogeneousAlternationExpression.Index) -> Bool {
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
	
	public static func ==(firstIndex: HomogeneousAlternationExpression.Index, otherIndex: HomogeneousAlternationExpression.Index) -> Bool {
		switch (firstIndex, otherIndex) {
			
			case (.inSubexpression(subexpressionIndex: let firstSubexpressionIndex, innerIndex: let firstInnerIndex), .inSubexpression(subexpressionIndex: let otherSubexpressionIndex, innerIndex: let otherInnerIndex)):
			return (firstSubexpressionIndex, firstInnerIndex) == (otherSubexpressionIndex, otherInnerIndex)
			
			case (.delimiter(indexOfPreviousSubexpression: let firstIndex), .delimiter(indexOfPreviousSubexpression: let otherIndex)):
			return firstIndex == otherIndex
			
			case (.end, .end):
			return true
			
			default:
			return false
			
		}
	}
	
}
