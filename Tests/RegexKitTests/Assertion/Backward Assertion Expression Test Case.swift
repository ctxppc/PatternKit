// PatternKit © 2017–21 Constantino Tsarouhas

import RegexKit
import XCTest

class BackwardAssertionExpressionTestCase : XCTestCase {
	
	func testSimple() {
		let expression = BackwardAssertionExpression(LiteralExpression("hello"))
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == "(?<=hello)")
	}
	
}
