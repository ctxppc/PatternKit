// PatternKit © 2017–21 Constantino Tsarouhas

import RegexKit
import XCTest

class ConcatenatedExpressionTestCase : XCTestCase {
	
	func testSimple() {
		let expression = ConcatenatedExpression(LiteralExpression("aa"), LiteralExpression("bb"))
		XCTAssert(try! expression.serialisation(language: .ecmaScript) == "aabb")
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == "aabb")
	}
	
	func testEmpty() {
		
		let emptyLeadingExpression = ConcatenatedExpression(EmptyExpression(), LiteralExpression("bb"))
		XCTAssert(try! emptyLeadingExpression.serialisation(language: .ecmaScript) == "bb")
		XCTAssert(try! emptyLeadingExpression.serialisation(language: .perlCompatibleREs) == "bb")
		
		let emptyTrailingExpression = ConcatenatedExpression(LiteralExpression("aa"), EmptyExpression())
		XCTAssert(try! emptyTrailingExpression.serialisation(language: .ecmaScript) == "aa")
		XCTAssert(try! emptyTrailingExpression.serialisation(language: .perlCompatibleREs) == "aa")
		
	}
	
}
