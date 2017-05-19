// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class WildcardsTestCase : XCTestCase {
	
	func testSingleWildcard() {
		XCTAssert(![].matches(Wildcard<[Int]>()))
		XCTAssert([5].matches(Wildcard()))
		XCTAssert(![5, 6].matches(Wildcard()))
	}
	
	func testTwoWildcards() {
		XCTAssert(![Int]().matches(Wildcard() • Wildcard()))
		XCTAssert(![5].matches(Wildcard() • Wildcard()))
		XCTAssert([5, 6].matches(Wildcard() • Wildcard()))
		XCTAssert(![5, 6, 5].matches(Wildcard() • Wildcard()))
	}
	
	func testHelloString() {
		XCTAssert("hello".characters.matches(Wildcard() • Wildcard() • Wildcard() • Wildcard() • Wildcard()))
		XCTAssert(!"hello".characters.matches(Wildcard() • Wildcard() • Wildcard() • Wildcard()))
		XCTAssert(!"hello".characters.matches(Wildcard() • Wildcard() • Wildcard() • Wildcard() • Wildcard() • Wildcard()))
	}
	
	func testEmptyString() {
		XCTAssert(!"".characters.matches(Wildcard()))
		XCTAssert(!"".characters.matches(Wildcard() • Wildcard()))
	}
	
}
