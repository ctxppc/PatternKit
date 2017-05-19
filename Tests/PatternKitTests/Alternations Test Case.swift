// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class AlternationsTestCase : XCTestCase {
	
	func testCharacterLiterals() {
		XCTAssert("a".characters.matches("a" | "b"))
		XCTAssert("a".characters.matches("b" | "a"))
		XCTAssert(!"a".characters.matches("b" | "c"))
	}
	
	func testStringLiterals() {
		XCTAssert("abba".characters.matches("abba".characters | "baab".characters))
		XCTAssert("abba".characters.matches("baab".characters | "abba".characters))
		XCTAssert(!"abba".characters.matches("baab".characters | "caac".characters))
	}
	
}
