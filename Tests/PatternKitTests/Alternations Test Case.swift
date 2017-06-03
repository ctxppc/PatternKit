// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class AlternationsTestCase : XCTestCase {
	
	func testEmptyLiterals() {
		
		XCTAssert("".matches(literal("") | literal("")))
		XCTAssert("".matches(literal("a") | literal("")))
		XCTAssert("".matches(literal("") | literal("a")))
		XCTAssert(!"".matches(literal("a") | literal("a")))
		
		XCTAssert(!"a".matches(literal("") | literal("")))
		XCTAssert("a".matches(literal("a") | literal("")))
		XCTAssert("a".matches(literal("") | literal("a")))
		
	}
	
	func testCharacterLiterals() {
		XCTAssert("a".matches("a" | "b"))
		XCTAssert("a".matches("b" | "a"))
		XCTAssert(!"a".matches("b" | "c"))
	}
	
	func testStringLiterals() {
		XCTAssert("abba".matches(literal("abba") | literal("baab")))
		XCTAssert("abba".matches(literal("baab") | literal("abba")))
		XCTAssert(!"abba".matches(literal("baab") | literal("caac")))
	}
	
}
