// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class LiteralsTestCase : XCTestCase {
	
	func testEmptyCollection() {
		XCTAssert([].matches(§[Int]()))
		XCTAssert(![].matches(§[1]))
		XCTAssert(![].matches(§[1, 2]))
	}
	
	func testCollectionOfOne() {
		XCTAssert([5].matches(§[5]))
		XCTAssert(![5].matches(§[]))
		XCTAssert(![5].matches(§[6]))
		XCTAssert(![5].matches(§[5, 6]))
		XCTAssert(![5].matches(§[6, 5]))
	}
	
	func testCollectionOfTwo() {
		XCTAssert([5, 6].matches(§[5, 6]))
		XCTAssert(![5, 6].matches(§[]))
		XCTAssert(![5, 6].matches(§[5]))
		XCTAssert(![5, 6].matches(§[6]))
		XCTAssert(![5, 6].matches(§[6, 5]))
	}
	
	func testHelloLiteral() {
		XCTAssert(!"".matches(§"hello"))
		XCTAssert("hello".matches(§"hello"))
		XCTAssert(!"helloo".matches(§"hello"))
		XCTAssert(!"ello".matches(§"hello"))
	}
	
	func testEmptyStringLiteral() {
		XCTAssert("".matches(§""))
		XCTAssert(!"h".matches(§""))
		XCTAssert(!"hello".matches(§""))
	}
	
}
