// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class RepeatingTestCase : XCTestCase {
	
	func testOptionalArrayLiterals() {
		XCTAssert([2, 2].matches([2]*))
		XCTAssert([1, 2, 2, 3].matches(§[1] • [2]* • §[3]))
		XCTAssert(![1, 2, 2, 3].matches([2]* • §[3]))
		XCTAssert(![1, 2, 2, 3].matches(§[1] • [2]*))
	}
	
	func testNonoptionalArrayLiterals() {
		XCTAssert([2, 2].matches([2]+))
		XCTAssert([1, 2, 2, 3].matches(§[1] • [2]+ • §[3]))
		XCTAssert(![1, 2, 2, 3].matches([2]+ • §[3]))
		XCTAssert(![1, 2, 2, 3].matches(§[1] • [2]+))
	}
	
	func testStringLiterals() {
		XCTAssert("abbbbbba".matches(§"a" • "b"+ • §"a"))
		XCTAssert("abbbbbba".matches(§"a" • "b"* • §"a"))
		XCTAssert("abbbbbba".matches("a"/? • "b"* • §"a"))
		XCTAssert("bbbbbba".matches("a"/? • "b"* • §"a"))
	}
	
}
