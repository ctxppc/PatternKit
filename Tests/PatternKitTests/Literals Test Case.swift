// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class LiteralsTestCase : XCTestCase {
	
	let emptyIntArray: [Int] = []
	
	func testEmptyCollection() {
		XCTAssert(emptyIntArray.matches(Literal(([]))))
		XCTAssert(!emptyIntArray.matches(Literal([1])))
		XCTAssert(!emptyIntArray.matches(Literal([1, 2])))
	}
	
	func testCollectionOfOne() {
		XCTAssert([5].matches(Literal([5])))
		XCTAssert(![5].matches(Literal([])))
		XCTAssert(![5].matches(Literal([6])))
		XCTAssert(![5].matches(Literal([5, 6])))
		XCTAssert(![5].matches(Literal([6, 5])))
	}
	
	func testCollectionOfTwo() {
		XCTAssert([5, 6].matches(Literal([5, 6])))
		XCTAssert(![5, 6].matches(Literal([])))
		XCTAssert(![5, 6].matches(Literal([5])))
		XCTAssert(![5, 6].matches(Literal([6])))
		XCTAssert(![5, 6].matches(Literal([6, 5])))
	}
	
	func testHelloLiteral() {
		XCTAssert(!"".matches(literal("hello")))
		XCTAssert("hello".matches(literal("hello")))
		XCTAssert(!"helloo".matches(literal("hello")))
		XCTAssert(!"ello".matches(literal("hello")))
	}

	func testEmptyStringLiteral() {
		XCTAssert("".matches(literal("")))
		XCTAssert(!"h".matches(literal("")))
		XCTAssert(!"hello".matches(literal("")))
	}
	
}
