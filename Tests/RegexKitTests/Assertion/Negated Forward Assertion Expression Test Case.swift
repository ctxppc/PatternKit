// PatternKit © 2017–21 Constantino Tsarouhas

import RegexKit
import XCTest

class NegatedForwardAssertionExpressionTestCase : XCTestCase {
	
	func testSimple() {
		let expression = NegatedForwardAssertionExpression(LiteralExpression("hello"))
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == "(?!hello)")
	}
	
}
