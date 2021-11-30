// PatternKit © 2017–21 Constantino Tsarouhas

import XCTest
@testable import PatternKitRegex

class HomogeneousAlternationExpressionTestCase : XCTestCase {
	
	func testSimple() {
		
		let binaryExpression = HomogeneousAlternationExpression(LiteralExpression("aa"), LiteralExpression("bb"))
		XCTAssert(try! binaryExpression.serialisation(language: .ecmaScript) == "aa|bb")
		XCTAssert(try! binaryExpression.serialisation(language: .perlCompatibleREs) == "aa|bb")
		
		let ternaryExpression = HomogeneousAlternationExpression(LiteralExpression("aa"), LiteralExpression("bb"), LiteralExpression("cc"))
		XCTAssert(try! ternaryExpression.serialisation(language: .ecmaScript) == "aa|bb|cc")
		XCTAssert(try! ternaryExpression.serialisation(language: .perlCompatibleREs) == "aa|bb|cc")
		
	}
	
	func testEmpty() {
		
		let binaryExpression = HomogeneousAlternationExpression(EmptyExpression(), EmptyExpression())
		XCTAssert(try! binaryExpression.serialisation(language: .ecmaScript) == "|")
		XCTAssert(try! binaryExpression.serialisation(language: .perlCompatibleREs) == "|")
		
		let ternaryExpression = HomogeneousAlternationExpression(EmptyExpression(), EmptyExpression(), EmptyExpression())
		XCTAssert(try! ternaryExpression.serialisation(language: .ecmaScript) == "||")
		XCTAssert(try! ternaryExpression.serialisation(language: .perlCompatibleREs) == "||")
		
	}
	
}
