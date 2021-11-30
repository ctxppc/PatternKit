// PatternKit © 2017–21 Constantino Tsarouhas

import PatternKit
import XCTest

class ConcatenationsTestCase : XCTestCase {
	
	func testCombinedArrayLiterals() {
		
		XCTAssert((Literal() • Literal(1, 2, 3, 4)).hasMatches(over: [1, 2, 3, 4]))
		XCTAssert((Literal(1) • Literal(2, 3, 4)).hasMatches(over: [1, 2, 3, 4]))
		XCTAssert((Literal(1, 2) • Literal(3, 4)).hasMatches(over: [1, 2, 3, 4]))
		XCTAssert((Literal(1, 2) • Literal(3, 4)).hasMatches(over: [1, 2, 3, 4]))
		XCTAssert((Literal(1, 2, 3) • Literal(4)).hasMatches(over: [1, 2, 3, 4]))
		XCTAssert((Literal(1, 2, 3, 4) • Literal()).hasMatches(over: [1, 2, 3, 4]))
		XCTAssert(!(Literal(1, 2) • Literal(4)).hasMatches(over: [1, 2, 3, 4]))
		
		XCTAssert((Literal() • Literal(1, 2, 3, 4)).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		XCTAssert((Literal(1) • Literal(2, 3, 4)).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		XCTAssert((Literal(1, 2) • Literal(3, 4)).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		XCTAssert((Literal(1, 2) • Literal(3, 4)).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		XCTAssert((Literal(1, 2, 3) • Literal(4)).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		XCTAssert((Literal(1, 2, 3, 4) • Literal()).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		XCTAssert(!(Literal(1, 2) • Literal(4)).hasMatches(over: [1, 2, 3, 4], direction: .backward))
		
	}
	
	func testSeparateArrayLiterals() {
		
		XCTAssert(Concatenation(Literal(), Literal(1, 2, 3)).hasMatches(over: [1, 2, 3]))
		XCTAssert(Concatenation(Literal(1), Literal(2, 3)).hasMatches(over: [1, 2, 3]))
		XCTAssert(Concatenation(Literal(1, 2), Literal(3)).hasMatches(over: [1, 2, 3]))
		XCTAssert(Concatenation(Literal(1, 2, 3), Literal()).hasMatches(over: [1, 2, 3]))
		XCTAssert(!Concatenation(Literal(), Literal(1, 2, 3)).hasMatches(over: [1, 2]))
		XCTAssert(!Concatenation(Literal(1), Literal(2, 3)).hasMatches(over: [1, 2]))
		XCTAssert(!Concatenation(Literal(1), Literal(2)).hasMatches(over: [1]))
		XCTAssert(!Concatenation(Literal(1), Literal(2)).hasMatches(over: [2]))
		
		XCTAssert(Concatenation(Literal(), Literal(1, 2, 3)).hasMatches(over: [1, 2, 3], direction: .backward))
		XCTAssert(Concatenation(Literal(1), Literal(2, 3)).hasMatches(over: [1, 2, 3], direction: .backward))
		XCTAssert(Concatenation(Literal(1, 2), Literal(3)).hasMatches(over: [1, 2, 3], direction: .backward))
		XCTAssert(Concatenation(Literal(1, 2, 3), Literal()).hasMatches(over: [1, 2, 3], direction: .backward))
		XCTAssert(!Concatenation(Literal(), Literal(1, 2, 3)).hasMatches(over: [1, 2], direction: .backward))
		XCTAssert(!Concatenation(Literal(1), Literal(2, 3)).hasMatches(over: [1, 2], direction: .backward))
		XCTAssert(!Concatenation(Literal(1), Literal(2)).hasMatches(over: [1], direction: .backward))
		XCTAssert(!Concatenation(Literal(1), Literal(2)).hasMatches(over: [2], direction: .backward))
		
	}
	
	func testStringLiterals() {
		
		XCTAssert((("a"..."b") • ("a"..."b") • ("a"..."b") • ("a"..."b")).hasMatches(over: "abba"))
		XCTAssert((("a"..."b") • Literal("bb") • ("a"..."b")).hasMatches(over: "abba"))
		XCTAssert(!(("a"..."b") • ("a"..."b") • ("a"..."b")).hasMatches(over: ""))
		XCTAssert(!(("a"..."b") • ("a"..."b") • ("a"..."b")).hasMatches(over: "abba"))
		
		XCTAssert((("a"..."b") • ("a"..."b") • ("a"..."b") • ("a"..."b")).hasMatches(over: "abba", direction: .backward))
		XCTAssert((("a"..."b") • Literal("bb") • ("a"..."b")).hasMatches(over: "abba", direction: .backward))
		XCTAssert(!(("a"..."b") • ("a"..."b") • ("a"..."b")).hasMatches(over: "", direction: .backward))
		XCTAssert(!(("a"..."b") • ("a"..."b") • ("a"..."b")).hasMatches(over: "abba", direction: .backward))
		
	}
	
}
