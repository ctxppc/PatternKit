// PatternKit © 2017–19 Constantino Tsarouhas

import XCTest
@testable import PatternKitRegex

class NegatedForwardAssertionExpressionTestCase : XCTestCase {
	
	func testSimple() {
		let expression = NegatedForwardAssertionExpression(LiteralExpression("hello"))
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == "(?!hello)")
	}
	
}
