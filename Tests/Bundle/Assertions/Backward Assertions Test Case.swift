// PatternKit © 2017–21 Constantino Tsarouhas

import XCTest
@testable import PatternKitBundle

class BackwardAssertionsTestCase : XCTestCase {
	
	func testSimpleAssertion() {
		XCTAssert((Literal("Hello") • ?<=Literal("Hello")).hasMatches(over: "Hello"))
		XCTAssert((Literal("Hello") • ?<=Literal("Hello")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testLeadingEmptyAssertion() {
		XCTAssert((?<=Literal("") • Literal("Hello")).hasMatches(over: "Hello"))
		XCTAssert((?<=Literal("") • Literal("Hello")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testMiddleEmptyAssertion() {
		XCTAssert((Literal("Hel") • ?<=Literal("") • Literal("lo")).hasMatches(over: "Hello"))
		XCTAssert((Literal("Hel") • ?<=Literal("") • Literal("lo")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testTrailingEmptyAssertion() {
		XCTAssert((Literal("Hello") • ?<=Literal("")).hasMatches(over: "Hello"))
		XCTAssert((Literal("Hello") • ?<=Literal("")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testMiddleStringAssertion() {
		XCTAssert((Literal("Hel") • ?<=Literal("el") • Literal("lo")).hasMatches(over: "Hello"))
		XCTAssert((Literal("Hel") • ?<=Literal("el") • Literal("lo")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testTrailingStringAssertion() {
		XCTAssert((Literal("Hello") • ?<=Literal("llo")).hasMatches(over: "Hello"))
		XCTAssert((Literal("Hello") • ?<=Literal("llo")).hasMatches(over: "Hello", direction: .backward))
	}
	
}
