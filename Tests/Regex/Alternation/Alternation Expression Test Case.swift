// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKitRegex

class AlternationExpressionTestCase : XCTestCase {
	
	func testSimple() {
		let expression = AlternationExpression(LiteralExpression("aa"), LiteralExpression("bb"))
		XCTAssert(try! expression.serialisation(language: .ecmaScript) == "aa|bb")
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == "aa|bb")
	}
	
	func testEmpty() {
		
		let emptyLeadingExpression = AlternationExpression(EmptyExpression(), LiteralExpression("bb"))
		XCTAssert(try! emptyLeadingExpression.serialisation(language: .ecmaScript) == "|bb")
		XCTAssert(try! emptyLeadingExpression.serialisation(language: .perlCompatibleREs) == "|bb")
		
		let emptyTrailingExpression = AlternationExpression(LiteralExpression("aa"), EmptyExpression())
		XCTAssert(try! emptyTrailingExpression.serialisation(language: .ecmaScript) == "aa|")
		XCTAssert(try! emptyTrailingExpression.serialisation(language: .perlCompatibleREs) == "aa|")
		
	}
	
}
