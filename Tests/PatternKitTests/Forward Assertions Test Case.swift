// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class ForwardAssertionsTestCase : XCTestCase {
	
	func testLeadingAssertion() {
		
		XCTAssert((ForwardAssertion(1...9) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4]))
		XCTAssert((ForwardAssertion(Repeating(1...9, exactly: 2)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4]))
		XCTAssert((ForwardAssertion(Repeating(1...9, exactly: 3)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4]))
		XCTAssert((ForwardAssertion(Repeating(1...9, exactly: 4)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4]))
		XCTAssert(!(ForwardAssertion(Repeating(1...9, exactly: 5)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4]))
		
		XCTAssert((ForwardAssertion(1...9) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		XCTAssert((ForwardAssertion(Repeating(1...9, exactly: 2)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		XCTAssert((ForwardAssertion(Repeating(1...9, exactly: 3)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		XCTAssert((ForwardAssertion(Repeating(1...9, exactly: 4)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		XCTAssert(!(ForwardAssertion(Repeating(1...9, exactly: 5)) • Literal([1, 2, 3, 4])).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		
	}
	
	// TODO
	
}
