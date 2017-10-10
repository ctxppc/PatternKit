// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKitRegex

class BackwardAssertionExpressionTestCase : XCTestCase {
	
	func testSimple() {
		let expression = BackwardAssertionExpression(LiteralExpression("hello"))
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == "(?<=hello)")
	}
	
}
