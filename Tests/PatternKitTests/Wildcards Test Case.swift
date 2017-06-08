// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class WildcardsTestCase : XCTestCase {
	
	let emptyIntArray: [Int] = []
	
	func testSingleWildcard() {
		XCTAssert(one().hasMatches(over: [5]))
		XCTAssert(!one().hasMatches(over: emptyIntArray))
		XCTAssert(!one().hasMatches(over: [5, 6]))
	}
	
	func testTwoWildcards() {
		XCTAssert((one() • one()).hasMatches(over: [5, 6]))
		XCTAssert(!(one() • one()).hasMatches(over: emptyIntArray))
		XCTAssert(!(one() • one()).hasMatches(over: [5]))
		XCTAssert(!(one() • one()).hasMatches(over: [5, 6, 7]))
	}
	
	func testHelloString() {
		XCTAssert((one() • one() • one() • one() • one()).hasMatches(over: "hello"))
		XCTAssert(!(one() • one() • one() • one()).hasMatches(over: "hello"))
		XCTAssert(!(one() • one() • one() • one() • one() • one()).hasMatches(over: "hello"))
	}
	
	func testEmptyString() {
		XCTAssert(!one().hasMatches(over: ""))
		XCTAssert(!(one() • one()).hasMatches(over: ""))
	}
	
}
