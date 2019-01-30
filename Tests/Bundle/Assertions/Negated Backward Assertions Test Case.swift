// PatternKit © 2017–19 Constantino Tsarouhas

import XCTest
@testable import PatternKitBundle

class NegatedBackwardAssertionsTestCase : XCTestCase {
	
	func testSimpleAssertion() {
		XCTAssert((Literal("Hello") • ?<!Literal("ell")).hasMatches(over: "Hello"))
		XCTAssert((Literal("Hello") • ?<!Literal("ell")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testLeadingAssertion() {
		XCTAssert((?<!Literal("H") • Literal("Hello")).hasMatches(over: "Hello"))
		XCTAssert((?<!Literal("H") • Literal("Hello")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testMiddleAssertion() {
		XCTAssert((Literal("Hel") • ?<!Literal("e") • Literal("lo")).hasMatches(over: "Hello"))
		XCTAssert((Literal("Hel") • ?<!Literal("e") • Literal("lo")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testTrailingAssertion() {
		XCTAssert((Literal("Hello") • ?<!Literal("l")).hasMatches(over: "Hello"))
		XCTAssert((Literal("Hello") • ?<!Literal("l")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testNegatedTrailingAssertion() {
		XCTAssert(!(Literal("Hello") • ?<!Literal("llo")).hasMatches(over: "Hello"))
		XCTAssert(!(Literal("Hello") • ?<!Literal("llo")).hasMatches(over: "Hello", direction: .backward))
	}
	
}
