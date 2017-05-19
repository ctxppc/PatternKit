// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class LiteralsTestCase : XCTestCase {
	
	func testEmptyCollection() {
		XCTAssert([].matches(Literal([Int]())))
		XCTAssert(![].matches(Literal([1])))
		XCTAssert(![].matches(Literal([1, 2])))
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
		XCTAssert(!"".characters.matches(Literal("hello".characters)))
		XCTAssert("hello".characters.matches(Literal("hello".characters)))
		XCTAssert(!"helloo".characters.matches(Literal("hello".characters)))
		XCTAssert(!"ello".characters.matches(Literal("hello".characters)))
	}
	
	func testEmptyStringLiteral() {
		XCTAssert("".characters.matches(Literal("".characters)))
		XCTAssert(!"h".characters.matches(Literal("".characters)))
		XCTAssert(!"hello".characters.matches(Literal("".characters)))
	}
	
}
