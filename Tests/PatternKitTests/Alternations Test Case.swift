// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class AlternationsTestCase : XCTestCase {
	
	func testEmptyLiterals() {
		
		XCTAssert((literal("") | literal("")).hasMatches(over: ""))
		XCTAssert((literal("a") | literal("")).hasMatches(over: ""))
		XCTAssert((literal("") | literal("a")).hasMatches(over: ""))
		XCTAssert(!(literal("a") | literal("a")).hasMatches(over: ""))
		
		XCTAssert((literal("a") | literal("")).hasMatches(over: "a"))
		XCTAssert((literal("") | literal("a")).hasMatches(over: "a"))
		XCTAssert(!(literal("") | literal("")).hasMatches(over: "a"))
		
	}
	
	func testCharacterLiterals() {
		XCTAssert(("a" | "b").hasMatches(over: "a"))
		XCTAssert(("b" | "a").hasMatches(over: "a"))
		XCTAssert(!("b" | "c").hasMatches(over: "a"))
	}
	
	func testStringLiterals() {
		XCTAssert((literal("abba") | literal("baab")).hasMatches(over: "abba"))
		XCTAssert((literal("baab") | literal("abba")).hasMatches(over: "abba"))
		XCTAssert(!(literal("baab") | literal("caac")).hasMatches(over: "abba"))
	}
	
}
