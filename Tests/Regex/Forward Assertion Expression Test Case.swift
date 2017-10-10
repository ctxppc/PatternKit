// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKitRegex

class ForwardAssertionExpressionTestCase : XCTestCase {
	
	func testSimple() {
		let expression = ForwardAssertionExpression(LiteralExpression("hello"))
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == "(?=hello)")
	}
	
}
