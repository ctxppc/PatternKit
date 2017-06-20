// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class NegatedBackwardAssertionsTestCase : XCTestCase {
	
	func testSimpleAssertion() {
		XCTAssert((literal("Hello") • ?<!literal("ell")).hasMatches(over: "Hello"))
		XCTAssert((literal("Hello") • ?<!literal("ell")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testLeadingAssertion() {
		XCTAssert((?<!literal("H") • literal("Hello")).hasMatches(over: "Hello"))
		XCTAssert((?<!literal("H") • literal("Hello")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testMiddleAssertion() {
		XCTAssert((literal("Hel") • ?<!literal("e") • literal("lo")).hasMatches(over: "Hello"))
		XCTAssert((literal("Hel") • ?<!literal("e") • literal("lo")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testTrailingAssertion() {
		XCTAssert((literal("Hello") • ?<!literal("l")).hasMatches(over: "Hello"))
		XCTAssert((literal("Hello") • ?<!literal("l")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testNegatedTrailingAssertion() {
		XCTAssert(!(literal("Hello") • ?<!literal("llo")).hasMatches(over: "Hello"))
		XCTAssert(!(literal("Hello") • ?<!literal("llo")).hasMatches(over: "Hello", direction: .backward))
	}
	
}
