// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class AlternationsTestCase : XCTestCase {
	
	func testCharacterLiterals() {
		XCTAssert("a".matches("a" | "b"))
		XCTAssert("a".matches("b" | "a"))
		XCTAssert(!"a".matches("b" | "c"))
	}
	
	func testStringLiterals() {
		XCTAssert("abba".matches(§"abba" | §"baab"))
		XCTAssert("abba".matches(§"baab" | §"abba"))
		XCTAssert(!"abba".matches(§"baab" | §"caac"))
	}
	
}
