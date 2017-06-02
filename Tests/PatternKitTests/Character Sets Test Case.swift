// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class CharacterSetsTestCase : XCTestCase {
	
	func testZeroCharacters() {
		XCTAssert(!"".matches("a"..."a"))
		XCTAssert(!"".matches("a"..."z"))
	}
	
	func testSingleCharacter() {
		XCTAssert("a".matches("a"..."a"))
		XCTAssert("a".matches("a"..."z"))
		XCTAssert(!"a".matches("A"..."Z"))
		XCTAssert(!"a".matches("A"..."A"))
	}
	
	func testTwoCharacters() {
		XCTAssert("ab".matches(("a"..."a") • ("b"..."b")))
		XCTAssert("ab".matches(("a"..."z") • ("a"..."z")))
		XCTAssert(!"ab".matches("A"..."Z"))
		XCTAssert(!"ab".matches(("A"..."A") • ("a"..."z")))
	}
	
}
