// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class RepeatingTestCase : XCTestCase {
	
	func testOptionalArrayLiterals() {
		XCTAssert(Literal(2)*.hasMatches(over: [2, 2]))
		XCTAssert((Literal(1) • Literal(2)* • Literal(3)).hasMatches(over: [1, 2, 2, 3]))
		XCTAssert(!(Literal(2)* • Literal(3)).hasMatches(over: [1, 2, 2, 3]))
		XCTAssert(!(Literal(1) • Literal(2)*).hasMatches(over: [1, 2, 2, 3]))
	}
	
	func testNonoptionalArrayLiterals() {
		XCTAssert(Literal(2)+.hasMatches(over: [2, 2]))
		XCTAssert((Literal(1) • Literal(2)+ • Literal(3)).hasMatches(over: [1, 2, 2, 3]))
		XCTAssert(!(Literal(2)+ • Literal(3)).hasMatches(over: [1, 2, 2, 3]))
		XCTAssert(!(Literal(1) • Literal(2)+).hasMatches(over: [1, 2, 2, 3]))
	}
	
	func testStringLiterals() {
		XCTAssert((literal("a") • literal("b")+ • literal("a")).hasMatches(over: "abbbbbba"))
		XCTAssert((literal("a") • literal("b")* • literal("a")).hasMatches(over: "abbbbbba"))
		XCTAssert((literal("a")/? • literal("b")* • literal("a")).hasMatches(over: "abbbbbba"))
		XCTAssert((literal("a")/? • literal("b")* • literal("a")).hasMatches(over: "bbbbbba"))
	}
	
}
