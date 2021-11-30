// PatternKit © 2017–21 Constantino Tsarouhas

import XCTest
import PatternKitCore
@testable import PatternKitBundle

class EagerlyRepeatingTestCase : XCTestCase {
	
	func testOptionalArrayLiterals() {
		XCTAssert(Literal(2)*.hasMatches(over: [2, 2]))
		XCTAssert((Literal(1) • Literal(2)* • Literal(3)).hasMatches(over: [1, 2, 2, 3]))
		XCTAssert(!(Literal(2)* • Literal(3)).hasMatches(over: [1, 2, 2, 3]))
		XCTAssert(!(Literal(1) • Literal(2)*).hasMatches(over: [1, 2, 2, 3]))
	}
	
	func testNonoptionalArrayLiterals() {
		XCTAssert(Literal(2)+.hasMatches(over: [2, 2]))
		XCTAssert((Literal(1) • Literal(2)+ • Literal(3)).hasMatches(over: [1, 2, 2, 3]))
		XCTAssert(!(Literal(2)+ • Literal(3)).hasMatches(over: [1, 2, 2, 3]))
		XCTAssert(!(Literal(1) • Literal(2)+).hasMatches(over: [1, 2, 2, 3]))
	}
	
	func testStringLiterals() {
		XCTAssert((Literal("a") • Literal("b")+ • Literal("a")).hasMatches(over: "abbbbbba"))
		XCTAssert((Literal("a") • Literal("b")* • Literal("a")).hasMatches(over: "abbbbbba"))
		XCTAssert((Literal("a")/? • Literal("b")* • Literal("a")).hasMatches(over: "abbbbbba"))
		XCTAssert((Literal("a")/? • Literal("b")* • Literal("a")).hasMatches(over: "bbbbbba"))
	}
	
	func testEagerness() {
		
		let base = "a"+
		let prefix = Token(base)
		let suffix = Token(base)
		let pattern = prefix • suffix
		
		let matches = pattern.matches(over: "aaa")
		let captures = Array(matches.map { (String($0.captures(for: prefix).first!), String($0.captures(for: suffix).first!)) })
		
		XCTAssert(captures[0] == ("aa", "a"))
		XCTAssert(captures[1] == ("a", "aa"))
		XCTAssert(captures.count == 2)
		
	}
	
}
