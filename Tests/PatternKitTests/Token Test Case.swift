// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class TokenTestCase : XCTestCase {
	
	func testLiteralToken() {
		
		let prefix = Literal([1])
		let token = Token(Literal([2, 3]))
		let suffix = Literal([4])
		
		let pattern = prefix • token • suffix
		let matches = pattern.matches(over: [1, 2, 3, 4])
		
		guard let match = matches.first, matches.count == 1 else { return XCTFail() }
		
		let captures = match.capturedSubsequences(for: token)
		guard let capture = captures.first, captures.count == 1 else { return XCTFail() }
		
		XCTAssert(capture == [2, 3])
		
	}
	
	func testBackwardLiteralToken() {
		
		let prefix = Literal([1])
		let token = Token(Literal([2, 3]))
		let suffix = Literal([4])
		
		let pattern = prefix • token • suffix
		let matches = pattern.backwardMatches(over: [1, 2, 3, 4])
		
		guard let match = matches.first, matches.count == 1 else { return XCTFail() }
		
		let captures = match.capturedSubsequences(for: token)
		guard let capture = captures.first, captures.count == 1 else { return XCTFail() }
		
		XCTAssert(capture == [2, 3])
		
	}
	
	func testCharacterSetToken() {
		
		let token = Token(("a"..."b") • ("a"..."b"))
		let pattern = literal("a") • token • literal("a")
		let matches = pattern.matches(over: "abba")
		
		guard let match = matches.first, matches.count == 1 else { return XCTFail() }
		
		let captures = match.capturedSubsequences(for: token)
		guard let capture = captures.first, captures.count == 1 else { return XCTFail() }
		
		XCTAssert(String(capture) == "bb")
		
	}
	
	func testBackwardCharacterSetToken() {
		
		let token = Token(("a"..."b") • ("a"..."b"))
		let pattern = literal("a") • token • literal("a")
		let matches = pattern.backwardMatches(over: "abba")
		
		guard let match = matches.first, matches.count == 1 else { return XCTFail() }
		
		let captures = match.capturedSubsequences(for: token)
		guard let capture = captures.first, captures.count == 1 else { return XCTFail() }
		
		XCTAssert(String(capture) == "bb")
		
	}
	
}
