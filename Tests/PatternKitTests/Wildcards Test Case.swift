// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class WildcardsTestCase : XCTestCase {
	
	func testSingleWildcard() {
		XCTAssert(![Int]().matches(one()))
		XCTAssert([5].matches(one()))
		XCTAssert(![5, 6].matches(one()))
	}
	
	func testTwoWildcards() {
		XCTAssert(![Int]().matches(one() • one()))
		XCTAssert(![5].matches(one() • one()))
		XCTAssert([5, 6].matches(one() • one()))
		XCTAssert(![5, 6, 5].matches(one() • one()))
	}
	
	func testHelloString() {
		XCTAssert("hello".characters.matches(one() • one() • one() • one() • one()))
		XCTAssert(!"hello".characters.matches(one() • one() • one() • one()))
		XCTAssert(!"hello".characters.matches(one() • one() • one() • one() • one() • one()))
	}
	
	func testEmptyString() {
		XCTAssert(!"".characters.matches(one()))
		XCTAssert(!"".characters.matches(one() • one()))
	}
	
}
