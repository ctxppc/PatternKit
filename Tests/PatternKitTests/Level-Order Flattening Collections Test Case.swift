// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class LevelOrderFlatteningCollectionsTestCase : XCTestCase {
	
	func testSingleton() {
		
		let tree = Tree("Node", [])
		
		let flattenedTree = tree.flattenedInLevelOrder()
		let elements = flattenedTree.map { $0.value }
		
		XCTAssert(elements == ["Node"])
		
	}
	
	func testBinaryTree() {
		
		let binaryTree = Tree("F", [
			Tree("B", [
				Tree("A", []),
				Tree("D", [
					Tree("C", []),
					Tree("E", [])
				])
			]),
			Tree("G", [
				Tree("I", [
					Tree("H", [])
				])
			])
		])
		
		let flattenedTree = binaryTree.flattenedInLevelOrder()
		let elements = flattenedTree.map { $0.value }
		
		XCTAssert(elements == ["F", "B", "G", "A", "D", "I", "C", "E", "H"])
		
	}
	
	func testArbitraryTree() {
		
		let tree = Tree("F", [
			Tree("B", [
				Tree("A", []),
				Tree("D", [
					Tree("C", []),
					Tree("X", []),
					Tree("E", [])
				])
			]),
			Tree("G", [
				Tree("I", [
					Tree("H", [])
				])
			])
		])
		
		let flattenedTree = tree.flattenedInLevelOrder()
		let elements = flattenedTree.map { $0.value }
		
		XCTAssert(elements == ["F", "B", "G", "A", "D", "I", "C", "X", "E", "H"])
		
	}
	
	func testInversedTree() {
		
		let tree = Tree("F", [
			Tree("B", [
				Tree("A", []),
				Tree("D", [
					Tree("C", []),
					Tree("E", []),
					Tree("X", [])
				])
			]),
			Tree("G", [
				Tree("I", [
					Tree("H", [])
				])
			])
		])
		
		let flattenedTree = tree.flattenedInPreOrder().reversed()
		let elements = flattenedTree.map { $0.value }
		
		XCTAssert(elements == ["F", "B", "G", "A", "D", "I", "C", "X", "E", "H"].reversed())
		
	}
	
	func testIndexOrdering() {
		
		let tree = Tree("F", [
			Tree("B", [
				Tree("A", []),
				Tree("D", [
					Tree("C", []),
					Tree("X", []),
					Tree("E", [])
				])
			]),
			Tree("G", [
				Tree("I", [
					Tree("H", [])
				])
			])
		])
		
		let indices = Array(tree.flattenedInLevelOrder().indices)
		XCTAssert(indices == indices.sorted())
		
	}
	
}
