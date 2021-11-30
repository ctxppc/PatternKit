// PatternKit © 2017–21 Constantino Tsarouhas

import PatternKit
import XCTest

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
		XCTAssert(Literal("hello").hasMatches(over: "hello"))
		XCTAssert(!Literal("hello").hasMatches(over: ""))
		XCTAssert(!Literal("hello").hasMatches(over: "helloo"))
		XCTAssert(!Literal("hello").hasMatches(over: "ello"))
		XCTAssert(Literal("hello").hasMatches(over: "hello", direction: .backward))
		XCTAssert(!Literal("hello").hasMatches(over: "", direction: .backward))
		XCTAssert(!Literal("hello").hasMatches(over: "helloo", direction: .backward))
		XCTAssert(!Literal("hello").hasMatches(over: "ello", direction: .backward))
	}

	func testEmptyStringLiteral() {
		XCTAssert(Literal("").hasMatches(over: ""))
		XCTAssert(!Literal("").hasMatches(over: "h"))
		XCTAssert(!Literal("").hasMatches(over: "hello"))
		XCTAssert(Literal("").hasMatches(over: "", direction: .backward))
		XCTAssert(!Literal("").hasMatches(over: "h", direction: .backward))
		XCTAssert(!Literal("").hasMatches(over: "hello", direction: .backward))
	}
	
}
