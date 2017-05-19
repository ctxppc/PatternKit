// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class CharacterSetsTestCase : XCTestCase {
	
	func testZeroCharacters() {
		XCTAssert(!"".characters.matches("a"..."a"))
		XCTAssert(!"".characters.matches("a"..."z"))
	}
	
	func testSingleCharacter() {
		XCTAssert("a".characters.matches("a"..."a"))
		XCTAssert("a".characters.matches("a"..."z"))
		XCTAssert(!"a".characters.matches("A"..."Z"))
		XCTAssert(!"a".characters.matches("A"..."A"))
	}
	
	func testTwoCharacters() {
		XCTAssert("ab".characters.matches(("a"..."a") • ("b"..."b")))
		XCTAssert("ab".characters.matches(("a"..."z") • ("a"..."z")))
		XCTAssert(!"ab".characters.matches("A"..."Z"))
		XCTAssert(!"ab".characters.matches(("A"..."A") • ("a"..."z")))
	}
	
}
