// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class PreOrderFlatteningCollectionsTestCase : XCTestCase {
	
	func testSingleton() {
		
		let tree = Tree("Node", [])
		
		let flattenedTree = tree.flattenedInPreorder()
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
		
		let flattenedTree = binaryTree.flattenedInPreorder()
		let elements = flattenedTree.map { $0.value }
		
		XCTAssert(elements == ["F", "B", "A", "D", "C", "E", "G", "I", "H"])
		
	}
	
	func testArbitraryTree() {
		
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
		
		let flattenedTree = tree.flattenedInPreorder()
		let elements = flattenedTree.map { $0.value }
		
		XCTAssert(elements == ["F", "B", "A", "D", "C", "E", "X", "G", "I", "H"])
		
	}
	
}
