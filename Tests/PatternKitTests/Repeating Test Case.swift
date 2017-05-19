// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class RepeatingTestCase : XCTestCase {
	
	func testOptionalArrayLiterals() {
		XCTAssert([2, 2].matches(Literal([2])*))
		XCTAssert([1, 2, 2, 3].matches(Literal([1]) • Literal([2])* • Literal([3])))
		XCTAssert(![1, 2, 2, 3].matches(Literal([2])* • Literal([3])))
		XCTAssert(![1, 2, 2, 3].matches(Literal([1]) • Literal([2])*))
	}
	
	func testNonoptionalArrayLiterals() {
		XCTAssert([2, 2].matches(Literal([2])+))
		XCTAssert([1, 2, 2, 3].matches(Literal([1]) • Literal([2])+ • Literal([3])))
		XCTAssert(![1, 2, 2, 3].matches(Literal([2])+ • Literal([3])))
		XCTAssert(![1, 2, 2, 3].matches(Literal([1]) • Literal([2])+))
	}
	
	func testStringLiterals() {
		XCTAssert("abbbbbba".characters.matches(Literal("a".characters) • Literal("b".characters)+ • Literal("a".characters)))
		XCTAssert("abbbbbba".characters.matches(Literal("a".characters) • Literal("b".characters)* • Literal("a".characters)))
		XCTAssert("abbbbbba".characters.matches(Literal("a".characters)/? • Literal("b".characters)* • Literal("a".characters)))
		XCTAssert("bbbbbba".characters.matches(Literal("a".characters)/? • Literal("b".characters)* • Literal("a".characters)))
	}
	
}
