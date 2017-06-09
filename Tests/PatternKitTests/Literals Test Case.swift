// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class LiteralsTestCase : XCTestCase {
	
	let emptyIntArray: [Int] = []
	
	func testEmptyCollection() {
		XCTAssert(Literal().hasMatches(over: emptyIntArray))
		XCTAssert(!Literal(1).hasMatches(over: emptyIntArray))
		XCTAssert(!Literal(1, 2).hasMatches(over: emptyIntArray))
		XCTAssert(Literal().hasMatches(over: emptyIntArray, direction: .backward))
		XCTAssert(!Literal(1).hasMatches(over: emptyIntArray, direction: .backward))
		XCTAssert(!Literal(1, 2).hasMatches(over: emptyIntArray, direction: .backward))
	}
	
	func testCollectionOfOne() {
		XCTAssert(Literal(5).hasMatches(over: [5]))
		XCTAssert(!Literal().hasMatches(over: [5]))
		XCTAssert(!Literal(6).hasMatches(over: [5]))
		XCTAssert(!Literal(6, 5).hasMatches(over: [5]))
		XCTAssert(!Literal(5, 6).hasMatches(over: [5]))
		XCTAssert(Literal(5).hasMatches(over: [5], direction: .backward))
		XCTAssert(!Literal().hasMatches(over: [5], direction: .backward))
		XCTAssert(!Literal(6).hasMatches(over: [5], direction: .backward))
		XCTAssert(!Literal(6, 5).hasMatches(over: [5], direction: .backward))
		XCTAssert(!Literal(5, 6).hasMatches(over: [5], direction: .backward))
	}
	
	func testCollectionOfTwo() {
		XCTAssert(Literal(5, 6).hasMatches(over: [5, 6]))
		XCTAssert(!Literal().hasMatches(over: [5, 6]))
		XCTAssert(!Literal(6).hasMatches(over: [5, 6]))
		XCTAssert(!Literal(5).hasMatches(over: [5, 6]))
		XCTAssert(!Literal(6, 5).hasMatches(over: [5, 6]))
		XCTAssert(Literal(5, 6).hasMatches(over: [5, 6], direction: .backward))
		XCTAssert(!Literal().hasMatches(over: [5, 6], direction: .backward))
		XCTAssert(!Literal(6).hasMatches(over: [5, 6], direction: .backward))
		XCTAssert(!Literal(5).hasMatches(over: [5, 6], direction: .backward))
		XCTAssert(!Literal(6, 5).hasMatches(over: [5, 6], direction: .backward))
	}
	
	func testHelloLiteral() {
		XCTAssert(literal("hello").hasMatches(over: "hello"))
		XCTAssert(!literal("hello").hasMatches(over: ""))
		XCTAssert(!literal("hello").hasMatches(over: "helloo"))
		XCTAssert(!literal("hello").hasMatches(over: "ello"))
		XCTAssert(literal("hello").hasMatches(over: "hello", direction: .backward))
		XCTAssert(!literal("hello").hasMatches(over: "", direction: .backward))
		XCTAssert(!literal("hello").hasMatches(over: "helloo", direction: .backward))
		XCTAssert(!literal("hello").hasMatches(over: "ello", direction: .backward))
	}

	func testEmptyStringLiteral() {
		XCTAssert(literal("").hasMatches(over: ""))
		XCTAssert(!literal("").hasMatches(over: "h"))
		XCTAssert(!literal("").hasMatches(over: "hello"))
		XCTAssert(literal("").hasMatches(over: "", direction: .backward))
		XCTAssert(!literal("").hasMatches(over: "h", direction: .backward))
		XCTAssert(!literal("").hasMatches(over: "hello", direction: .backward))
	}
	
}
