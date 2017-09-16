// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class AlternationsTestCase : XCTestCase {
	
	func testEmptyLiterals() {
		
		XCTAssert((Literal("") | Literal("")).hasMatches(over: ""))
		XCTAssert((Literal("a") | Literal("")).hasMatches(over: ""))
		XCTAssert((Literal("") | Literal("a")).hasMatches(over: ""))
		XCTAssert(!(Literal("a") | Literal("a")).hasMatches(over: ""))
		
		XCTAssert((Literal("a") | Literal("")).hasMatches(over: "a"))
		XCTAssert((Literal("") | Literal("a")).hasMatches(over: "a"))
		XCTAssert(!(Literal("") | Literal("")).hasMatches(over: "a"))
		
	}
	
	func testCharacterLiterals() {
		XCTAssert(("a" | "b").hasMatches(over: "a"))
		XCTAssert(("b" | "a").hasMatches(over: "a"))
		XCTAssert(!("b" | "c").hasMatches(over: "a"))
	}
	
	func testStringLiterals() {
		XCTAssert((Literal("abba") | Literal("baab")).hasMatches(over: "abba"))
		XCTAssert((Literal("baab") | Literal("abba")).hasMatches(over: "abba"))
		XCTAssert(!(Literal("baab") | Literal("caac")).hasMatches(over: "abba"))
	}
	
}
