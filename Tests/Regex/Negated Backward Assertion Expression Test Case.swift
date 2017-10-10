// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKitRegex

class NegatedBackwardAssertionExpressionTestCase : XCTestCase {
	
	func testSimple() {
		let expression = NegatedBackwardAssertionExpression(LiteralExpression("hello"))
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == "(?<!hello)")
	}
	
}
