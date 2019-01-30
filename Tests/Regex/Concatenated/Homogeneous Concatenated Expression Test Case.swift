// PatternKit © 2017–19 Constantino Tsarouhas

import XCTest
@testable import PatternKitRegex

class HomogeneousConcatenatedExpressionTestCase : XCTestCase {
	
	func testSimple() {
		
		let binaryExpression = HomogeneousConcatenatedExpression(LiteralExpression("aa"), LiteralExpression("bb"))
		XCTAssert(try! binaryExpression.serialisation(language: .ecmaScript) == "aabb")
		XCTAssert(try! binaryExpression.serialisation(language: .perlCompatibleREs) == "aabb")
		
		let ternaryExpression = HomogeneousConcatenatedExpression(LiteralExpression("aa"), LiteralExpression("bb"), LiteralExpression("cc"))
		XCTAssert(try! ternaryExpression.serialisation(language: .ecmaScript) == "aabbcc")
		XCTAssert(try! ternaryExpression.serialisation(language: .perlCompatibleREs) == "aabbcc")
		
	}
	
	func testEmpty() {
		
		let binaryExpression = HomogeneousConcatenatedExpression(EmptyExpression(), EmptyExpression())
		XCTAssert(try! binaryExpression.serialisation(language: .ecmaScript) == "")
		XCTAssert(try! binaryExpression.serialisation(language: .perlCompatibleREs) == "")
		
		let ternaryExpression = HomogeneousConcatenatedExpression(EmptyExpression(), EmptyExpression(), EmptyExpression())
		XCTAssert(try! ternaryExpression.serialisation(language: .ecmaScript) == "")
		XCTAssert(try! ternaryExpression.serialisation(language: .perlCompatibleREs) == "")
		
	}
	
}
