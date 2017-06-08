// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class CharacterSetsTestCase : XCTestCase {
	
	func testZeroCharacters() {
		XCTAssert(!("a"..."a").hasMatches(over: ""))
		XCTAssert(!("a"..."z").hasMatches(over: ""))
	}
	
	func testSingleCharacter() {
		XCTAssert(("a"..."a").hasMatches(over: "a"))
		XCTAssert(("a"..."z").hasMatches(over: "a"))
		XCTAssert(!("A"..."Z").hasMatches(over: "a"))
		XCTAssert(!("A"..."A").hasMatches(over: "a"))
	}
	
	func testTwoCharacters() {
		XCTAssert((("a"..."a") • ("b"..."b")).hasMatches(over: "ab"))
		XCTAssert((("a"..."z") • ("a"..."z")).hasMatches(over: "ab"))
		XCTAssert(!("A"..."Z").hasMatches(over: "ab"))
		XCTAssert(!(("A"..."A") • ("a"..."z")).hasMatches(over: "ab"))
	}
	
}
