// PatternKit © 2017–19 Constantino Tsarouhas

import XCTest
import PatternKitCore
@testable import PatternKitBundle

class CharacterSetsTestCase : XCTestCase {
	
	func testZeroCharacters() {
		
		XCTAssert(!("a"..."a").hasMatches(over: ""))
		XCTAssert(!("a"..."z").hasMatches(over: ""))
		
		XCTAssert(!("a"..."a").hasMatches(over: "", direction: .backward))
		XCTAssert(!("a"..."z").hasMatches(over: "", direction: .backward))
		
	}
	
	func testSingleCharacter() {
		
		XCTAssert(("a"..."a").hasMatches(over: "a"))
		XCTAssert(("b"..."b").hasMatches(over: "b"))
		XCTAssert(("a"..."z").hasMatches(over: "a"))
		XCTAssert(!("A"..."Z").hasMatches(over: "a"))
		XCTAssert(!("A"..."A").hasMatches(over: "a"))
		XCTAssert(!("b"..."b").hasMatches(over: "a"))
		
		XCTAssert(("a"..."a").hasMatches(over: "a", direction: .backward))
		XCTAssert(("b"..."b").hasMatches(over: "b", direction: .backward))
		XCTAssert(("a"..."z").hasMatches(over: "a", direction: .backward))
		XCTAssert(!("A"..."Z").hasMatches(over: "a", direction: .backward))
		XCTAssert(!("A"..."A").hasMatches(over: "a", direction: .backward))
		XCTAssert(!("b"..."b").hasMatches(over: "a", direction: .backward))
		
	}
	
	func testTwoCharacters() {
		
		XCTAssert((("a"..."a") • ("b"..."b")).hasMatches(over: "ab"))
		XCTAssert((("a"..."a") • ("a"..."b")).hasMatches(over: "ab"))
		XCTAssert((("a"..."z") • ("a"..."z")).hasMatches(over: "ab"))
		XCTAssert(!("A"..."Z").hasMatches(over: "ab"))
		XCTAssert(!(("A"..."A") • ("a"..."z")).hasMatches(over: "ab"))
		XCTAssert(!(("b"..."b") • ("a"..."a")).hasMatches(over: "ab"))
		
		XCTAssert((("a"..."a") • ("b"..."b")).hasMatches(over: "ab", direction: .backward))
		XCTAssert((("a"..."a") • ("a"..."b")).hasMatches(over: "ab", direction: .backward))
		XCTAssert((("a"..."z") • ("a"..."z")).hasMatches(over: "ab", direction: .backward))
		XCTAssert(!("A"..."Z").hasMatches(over: "ab", direction: .backward))
		XCTAssert(!(("A"..."A") • ("a"..."z")).hasMatches(over: "ab", direction: .backward))
		XCTAssert(!(("b"..."b") • ("a"..."a")).hasMatches(over: "ab", direction: .backward))
		
	}
	
	func testCapturedCharacters() {
		
		let firstToken = Token("a"..."b")
		let secondToken = Token("a"..."b")
		let pattern = firstToken • secondToken
		
		let matches = pattern.matches(over: "ab")
		guard let firstMatch = matches.first else { return XCTFail() }
		guard let firstCapture = firstMatch.capturedSubsequences(for: firstToken).first else { return XCTFail() }
		guard let secondCapture = firstMatch.capturedSubsequences(for: secondToken).first else { return XCTFail() }
		
		XCTAssert(String(firstCapture) == "a")
		XCTAssert(String(secondCapture) == "b")
		
	}
	
	func testBackwardCapturedCharacters() {
		
		let firstToken = Token("a"..."b")
		let secondToken = Token("a"..."b")
		let pattern = firstToken • secondToken
		
		let matches = pattern.backwardMatches(over: "ab")
		guard let firstMatch = matches.first else { return XCTFail() }
		guard let firstCapture = firstMatch.capturedSubsequences(for: firstToken).first else { return XCTFail() }
		guard let secondCapture = firstMatch.capturedSubsequences(for: secondToken).first else { return XCTFail() }
		
		XCTAssert(String(firstCapture) == "a")
		XCTAssert(String(secondCapture) == "b")
		
	}
	
}
