// PatternKit © 2017–21 Constantino Tsarouhas

import PatternKit
import XCTest

class WildcardsTestCase : XCTestCase {
	
	let emptyIntArray: [Int] = []
	
	func testSingleWildcard() {
		XCTAssert(one().hasMatches(over: [5]))
		XCTAssert(!one().hasMatches(over: emptyIntArray))
		XCTAssert(!one().hasMatches(over: [5, 6]))
		XCTAssert(one().hasMatches(over: [5], direction: .backward))
		XCTAssert(!one().hasMatches(over: emptyIntArray, direction: .backward))
		XCTAssert(!one().hasMatches(over: [5, 6], direction: .backward))
	}
	
	func testTwoWildcards() {
		XCTAssert((one() • one()).hasMatches(over: [5, 6]))
		XCTAssert(!(one() • one()).hasMatches(over: emptyIntArray))
		XCTAssert(!(one() • one()).hasMatches(over: [5]))
		XCTAssert(!(one() • one()).hasMatches(over: [5, 6, 7]))
		XCTAssert((one() • one()).hasMatches(over: [5, 6], direction: .backward))
		XCTAssert(!(one() • one()).hasMatches(over: emptyIntArray, direction: .backward))
		XCTAssert(!(one() • one()).hasMatches(over: [5], direction: .backward))
		XCTAssert(!(one() • one()).hasMatches(over: [5, 6, 7], direction: .backward))
	}
	
	func testHelloString() {
		XCTAssert((one() • one() • one() • one() • one()).hasMatches(over: "hello"))
		XCTAssert(!(one() • one() • one() • one()).hasMatches(over: "hello"))
		XCTAssert(!(one() • one() • one() • one() • one() • one()).hasMatches(over: "hello"))
		XCTAssert((one() • one() • one() • one() • one()).hasMatches(over: "hello", direction: .backward))
		XCTAssert(!(one() • one() • one() • one()).hasMatches(over: "hello", direction: .backward))
		XCTAssert(!(one() • one() • one() • one() • one() • one()).hasMatches(over: "hello", direction: .backward))
	}
	
	func testEmptyString() {
		XCTAssert(!one().hasMatches(over: ""))
		XCTAssert(!(one() • one()).hasMatches(over: ""))
		XCTAssert(!one().hasMatches(over: "", direction: .backward))
		XCTAssert(!(one() • one()).hasMatches(over: "", direction: .backward))
	}
	
}
