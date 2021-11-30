// PatternKit © 2017–21 Constantino Tsarouhas

import RegexKit
import XCTest

class ForwardAssertionExpressionTestCase : XCTestCase {
	
	func testSimple() {
		let expression = ForwardAssertionExpression(LiteralExpression("hello"))
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == "(?=hello)")
	}
	
}
