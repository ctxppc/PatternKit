// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class NegatedForwardAssertionsTestCase : XCTestCase {
	
	func testLeadingStringAssertion() {
		XCTAssert((?!literal("ell") • literal("Hello")).hasMatches(over: "Hello"))
		XCTAssert((?!literal("ell") • literal("Hello")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testMiddleStringAssertion() {
		XCTAssert((literal("Hel") • ?!literal("e") • literal("lo")).hasMatches(over: "Hello"))
		XCTAssert((literal("Hel") • ?!literal("e") • literal("lo")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testTrailingStringAssertion() {
		XCTAssert((literal("Hello") • ?!literal("lo")).hasMatches(over: "Hello"))
		XCTAssert((literal("Hello") • ?!literal("lo")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testLeadingEmptyAssertion() {
		XCTAssert(!(?!literal("") • literal("Hello")).hasMatches(over: "Hello"))
		XCTAssert(!(?!literal("") • literal("Hello")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testMiddleEmptyAssertion() {
		XCTAssert(!(literal("Hel") • ?!literal("") • literal("lo")).hasMatches(over: "Hello"))
		XCTAssert(!(literal("Hel") • ?!literal("") • literal("lo")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testTrailingEmptyAssertion() {
		XCTAssert(!(literal("Hello") • ?!literal("")).hasMatches(over: "Hello"))
		XCTAssert(!(literal("Hello") • ?!literal("")).hasMatches(over: "Hello", direction: .backward))
	}
	
}
