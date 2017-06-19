// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class PostOrderFlatteningCollectionsTestCase : XCTestCase {
	
	func testSingleton() {
		
		let tree = Tree("Node", [])
		
		let flattenedTree = tree.flattenedInPostOrder()
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
		
		let flattenedTree = binaryTree.flattenedInPostOrder()
		let elements = flattenedTree.map { $0.value }
		
		XCTAssert(elements == ["A", "C", "E", "D", "B", "H", "I", "G", "F"])
		
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
		
		let flattenedTree = tree.flattenedInPostOrder()
		let elements = flattenedTree.map { $0.value }
		
		XCTAssert(elements == ["A", "C", "X", "E", "D", "B", "H", "I", "G", "F"])
		
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
		
		let flattenedTree = tree.flattenedInPostOrder().reversed()
		let elements = flattenedTree.map { $0.value }
		
		XCTAssert(elements == ["A", "C", "X", "E", "D", "B", "H", "I", "G", "F"].reversed())
		
	}
	
	func testIndexOrdering() {
		
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
		
		let indices = Array(tree.flattenedInPostOrder().indices)
		XCTAssert(indices == indices.sorted())
		
	}
	
}