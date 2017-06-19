// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class ForwardAssertionsTestCase : XCTestCase {
	
	func testStandaloneAssertion() {
		let matches = ForwardAssertion(1...9).forwardMatches(enteringFrom: Match(over: [1], direction: .forward))
		guard let match = matches.first, matches.count == 1 else { return XCTFail() }
		XCTAssert(match.inputPosition == 0)
	}
	
	func testHeadingEmptyAssertion() {
		XCTAssert((?=literal("") • literal("Hello")).hasMatches(over: "Hello"))
		XCTAssert((?=literal("") • literal("Hello")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testMiddleEmptyAssertion() {
		XCTAssert((literal("Hel") • ?=literal("") • literal("lo")).hasMatches(over: "Hello"))
		XCTAssert((literal("Hel") • ?=literal("") • literal("lo")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testTrailingEmptyAssertion() {
		XCTAssert((literal("Hello") • ?=literal("")).hasMatches(over: "Hello"))
		XCTAssert((literal("Hello") • ?=literal("")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testLeadingStringAssertion() {
		XCTAssert((?=literal("Hel") • literal("Hello")).hasMatches(over: "Hello"))
		XCTAssert((?=literal("Hel") • literal("Hello")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testMiddleStringAssertion() {
		XCTAssert((literal("Hel") • ?=literal("l") • literal("lo")).hasMatches(over: "Hello"))
		XCTAssert((literal("Hel") • ?=literal("l") • literal("lo")).hasMatches(over: "Hello", direction: .backward))
	}
	
	func testLeadingAssertion() {
		
		XCTAssert((ForwardAssertion(1...9) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4]))
		XCTAssert((ForwardAssertion(repeating(1...9, exactly: 2)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4]))
		XCTAssert((ForwardAssertion(repeating(1...9, exactly: 3)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4]))
		XCTAssert((ForwardAssertion(repeating(1...9, exactly: 4)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4]))
		XCTAssert(!(ForwardAssertion(repeating(1...9, exactly: 5)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4]))
		
		XCTAssert((ForwardAssertion(1...9) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		XCTAssert((ForwardAssertion(repeating(1...9, exactly: 2)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		XCTAssert((ForwardAssertion(repeating(1...9, exactly: 3)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		XCTAssert((ForwardAssertion(repeating(1...9, exactly: 4)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		XCTAssert(!(ForwardAssertion(repeating(1...9, exactly: 5)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		
	}
	
	// TODO
	
}
