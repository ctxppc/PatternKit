// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class PreOrderFlatteningCollectionsTestCase : XCTestCase {
	
	func testSingleton() {
		
		let tree = Tree("Node", [])
		
		let flattenedTree = tree.flattenedInPreOrder()
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
		
		let flattenedTree = binaryTree.flattenedInPreOrder()
		let elements = flattenedTree.map { $0.value }
		
		XCTAssert(elements == ["F", "B", "A", "D", "C", "E", "G", "I", "H"])
		
	}
	
	// https://en.wikipedia.org/wiki/Tree_traversal
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
	
	let preorder = ["F", "B", "A", "D", "C", "X", "E", "G", "I", "H"]
	
	func testArbitraryTree() {
		
		let flattenedTree = tree.flattenedInPreOrder()
		let elements = flattenedTree.map { $0.value }
		
		XCTAssert(elements == preorder)
		
	}
	
	func testInversedTree() {
		
		let flattenedTree = tree.flattenedInPreOrder().reversed()
		let elements = flattenedTree.map { $0.value }
		
		XCTAssert(elements == preorder.reversed())
		
	}
	
	func testIndexOrdering() {
		
		let indices = Array(tree.flattenedInPreOrder().indices)
		XCTAssert(indices == indices.sorted())
		
	}
	
}
