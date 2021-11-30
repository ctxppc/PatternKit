// PatternKit © 2017–21 Constantino Tsarouhas

import XCTest
@testable import PatternKitRegex

class CommentExpressionTestCase : XCTestCase {
	
	func testSimple() {
		let expression = CommentRegularExpression("test string")
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == "(?#test string)")
	}
	
	func testNested() {
		let expression = CommentRegularExpression("(?#test string")
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == "(?#(?#test string)")
	}
	
}
