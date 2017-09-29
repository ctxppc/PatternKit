// PatternKit © 2017 Constantino Tsarouhas

import DepthKit

/// A regular expression that concatenates two or more subexpressions of the same type.
public struct HomogeneousConcatenatedRegularExpression<Subexpression : RegularExpression> where Subexpression.Indices : BidirectionalCollection {
	
	/// Creates a homogeneous concatenated regular expression with given subexpressions.
	///
	/// - Parameter firstExpression: The first subexpression.
	/// - Parameter otherExpressions: The other subexpressions.
	public init(_ firstExpression: Subexpression, _ otherExpressions: Subexpression...) {
		self.subexpressions = [firstExpression] + otherExpressions
	}
	
	/// Creates a homogeneous concatenated regular expression with given subexpressions.
	///
	/// - Requires: `subexpressions` contains at least two subexpressions.
	///
	/// - Parameter subexpressions: The subexpressions.
	public init(_ subexpressions: [Subexpression]) {
		precondition(subexpressions.count >= 2, "Fewer than 2 subexpressions in concatenation")
		self.subexpressions = subexpressions
	}
	
	/// The concatenated subexpressions.
	///
	/// - Invariant: `subexpressions` contains at least two subexpressions.
	public var subexpressions: [Subexpression] {
		willSet {
			precondition(newValue.count >= 2, "Fewer than 2 subexpressions in concatenation")
		}
	}
	
}

extension HomogeneousConcatenatedRegularExpression : RegularExpression {
	
	public enum Index {
		
		/// A position to a symbol in a subexpression.
		///
		/// - Parameter subexpressionIndex: The position of the subexpression.
		/// - Parameter innerIndex: The position of the symbol within the subexpression.
		case inSubexpression(subexpressionIndex: Int, innerIndex: Subexpression.Index)
		
		/// The position after the last symbol.
		case end
		
	}
	
	public var startIndex: Index {
		
		for (subexpressionIndex, subexpression) in subexpressions.enumerated() {
			if let firstIndex = subexpression.indices.first {
				return .inSubexpression(subexpressionIndex: subexpressionIndex, innerIndex: firstIndex)
			}
		}
		
		return .end
		
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> Symbol {
		guard case .inSubexpression(subexpressionIndex: let subexpressionIndex, innerIndex: let innerIndex) = index else { indexOutOfBounds }
		return subexpressions[subexpressionIndex][innerIndex]
	}
	
	public func index(before index: Index) -> Index {
		
		func lastIndexInSubexpressionPrecedingSubexpression(at subexpressionIndex: Int) -> Index {
			
			let remainingSubexpressions = subexpressions[..<subexpressionIndex].reversed()
			let remainingSubexpressionIndices = subexpressions.indices[..<subexpressionIndex].reversed()
			
			for (subexpressionIndex, subexpression) in zip(remainingSubexpressionIndices, remainingSubexpressions) {
				if let lastInnerIndex = subexpression.indices.last {
					return .inSubexpression(subexpressionIndex: subexpressionIndex, innerIndex: lastInnerIndex)
				}
			}
			
			indexOutOfBounds
			
		}
		
		switch index {
			
			case .inSubexpression(subexpressionIndex: let subexpressionIndex, innerIndex: let innerIndex):
			let subexpression = subexpressions[subexpressionIndex]
			if innerIndex > subexpression.startIndex {
				return .inSubexpression(subexpressionIndex: subexpressionIndex, innerIndex: subexpression.index(before: innerIndex))
			} else {
				return lastIndexInSubexpressionPrecedingSubexpression(at: subexpressionIndex)
			}
			
			case .end:
			return lastIndexInSubexpressionPrecedingSubexpression(at: subexpressions.endIndex)
			
		}
		
	}
	
	public func index(after index: Index) -> Index {
		
		guard case .inSubexpression(subexpressionIndex: let subexpressionIndex, innerIndex: let innerIndex) = index else { indexOutOfBounds }
		
		let subexpression = subexpressions[subexpressionIndex]
		let nextInnerIndex = subexpression.index(after: innerIndex)
		if nextInnerIndex < subexpression.endIndex {
			return .inSubexpression(subexpressionIndex: subexpressionIndex, innerIndex: nextInnerIndex)
		}
		
		let nextSubexpressionIndex = subexpressions.index(after: subexpressionIndex)
		
		for (subexpressionIndex, subexpression) in zip(subexpressions.indices[nextSubexpressionIndex...], subexpressions[nextSubexpressionIndex...]) {
			if let firstIndex = subexpression.indices.first {
				return .inSubexpression(subexpressionIndex: subexpressionIndex, innerIndex: firstIndex)
			}
		}
		
		return .end
		
	}
	
}

extension HomogeneousConcatenatedRegularExpression.Index : Comparable {
	
	public static func <(smallerIndex: HomogeneousConcatenatedRegularExpression.Index, greaterIndex: HomogeneousConcatenatedRegularExpression.Index) -> Bool {
		switch (smallerIndex, greaterIndex) {
			
			case (.inSubexpression(subexpressionIndex: let smallerSubexpressionIndex, innerIndex: let smallerInnerIndex), .inSubexpression(subexpressionIndex: let greaterSubexpressionIndex, innerIndex: let greaterInnerIndex)):
			return (smallerSubexpressionIndex, smallerInnerIndex) < (greaterSubexpressionIndex, greaterInnerIndex)
			
			case (.inSubexpression, .end):
			return true
			
			case (.end, _):
			return false
			
		}
	}
	
	public static func ==(firstIndex: HomogeneousConcatenatedRegularExpression.Index, otherIndex: HomogeneousConcatenatedRegularExpression.Index) -> Bool {
		switch (firstIndex, otherIndex) {
			
			case (.inSubexpression(subexpressionIndex: let firstSubexpressionIndex, innerIndex: let firstInnerIndex), .inSubexpression(subexpressionIndex: let otherSubexpressionIndex, innerIndex: let otherInnerIndex)):
			return (firstSubexpressionIndex, firstInnerIndex) == (otherSubexpressionIndex, otherInnerIndex)
			
			case (.end, .end):
			return true
			
			default:
			return false
			
		}
	}
	
}
