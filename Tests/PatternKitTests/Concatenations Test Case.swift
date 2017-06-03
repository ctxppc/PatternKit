// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class ConcatenationsTestCase : XCTestCase {
	
	func testCombinedArrayLiterals() {
		XCTAssert([1, 2, 3, 4].matches(Literal([]) •  Literal([1, 2, 3, 4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1]) •  Literal([2, 3, 4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1, 2]) • Literal([3, 4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1, 2]) • Literal([3, 4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1, 2, 3]) • Literal([4])))
		XCTAssert([1, 2, 3, 4].matches(Literal([1, 2, 3, 4]) • Literal([])))
	}
	
	func testSeparateArrayLiterals() {
		
		XCTAssert([1, 2, 3].matches(Concatenation(Literal([]), Literal([1, 2, 3]))))
		XCTAssert([1, 2, 3].matches(Concatenation(Literal([1]), Literal([2, 3]))))
		XCTAssert([1, 2, 3].matches(Concatenation(Literal([1, 2]), Literal([3]))))
		XCTAssert([1, 2, 3].matches(Concatenation(Literal([1, 2, 3]), Literal([]))))
		
		XCTAssert(![1, 2].matches(Concatenation(Literal([1]), Literal([1, 2]))))
		XCTAssert(![1, 2].matches(Concatenation(Literal([1, 2]), Literal([2]))))
		XCTAssert(![1].matches(Concatenation(Literal([1]), Literal([2]))))
		XCTAssert(![2].matches(Concatenation(Literal([1]), Literal([2]))))
		
	}
	
	func testStringLiterals() {
		XCTAssert(!"".matches(("a"..."b") • ("a"..."b") • ("a"..."b")))
		XCTAssert(!"abba".matches(("a"..."b") • ("a"..."b") • ("a"..."b")))
		XCTAssert("abba".matches(("a"..."b") • ("a"..."b") • ("a"..."b") • ("a"..."b")))
	}
	
}
