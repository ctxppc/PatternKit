// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class ConcatenationsTestCase : XCTestCase {
	
	func testArrayLiterals() {
		XCTAssert([1, 2, 3, 4].matches(Literal([]) •  Literal([1, 2, 3, 4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1]) •  Literal([2, 3, 4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1, 2]) • Literal([3, 4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1, 2]) • Literal([3, 4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1, 2, 3]) • Literal([4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1, 2, 3, 4]) • Literal([])))
	}
	
	func testSeparateArrayLiterals() {
		XCTAssert([1, 2, 3, 4].matches(Literal([]) • Token(Literal([])) • Literal([1, 2, 3, 4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1]) • Token(Literal([])) • Literal([2, 3, 4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1, 2]) • Token(Literal([])) • Literal([3, 4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1, 2]) • Token(Literal([])) • Literal([3, 4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1, 2, 3]) • Token(Literal([])) • Literal([4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1, 2, 3, 4]) • Token(Literal([])) • Literal([])))
	}
	
	func testStringLiterals() {
		XCTAssert(!"".characters.matches(("a"..."b") • ("a"..."b") • ("a"..."b")))
		XCTAssert(!"abba".characters.matches(("a"..."b") • ("a"..."b") • ("a"..."b")))
		XCTAssert("abba".characters.matches(("a"..."b") • ("a"..."b") • ("a"..."b") • ("a"..."b")))
	}
	
}
