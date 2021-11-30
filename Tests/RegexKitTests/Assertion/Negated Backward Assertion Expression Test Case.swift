// PatternKit © 2017–21 Constantino Tsarouhas

import RegexKit
import XCTest

class NegatedBackwardAssertionExpressionTestCase : XCTestCase {
	
	func testSimple() {
		let expression = NegatedBackwardAssertionExpression(LiteralExpression("hello"))
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == "(?<!hello)")
	}
	
}
