// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class PostOrderFlatteningCollectionsTestCase : XCTestCase {
	
	func testSingleton() {
		
		let tree = Tree("Node", [])
		
		let flattenedTree = tree.flattenedInPostorder()
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
		
		let flattenedTree = binaryTree.flattenedInPostorder()
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
		
		let flattenedTree = tree.flattenedInPostorder()
		let elements = flattenedTree.map { $0.value }
		
		XCTAssert(elements == ["A", "C", "X", "E", "D", "B", "H", "I", "G", "F"])
		
	}
	
}
