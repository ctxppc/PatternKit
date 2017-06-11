// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class RangePatternsTestCase : XCTestCase {
	
	func testHalfOpenRange() {
		
		XCTAssert((1..<9).hasMatches(over: [1]))
		XCTAssert((1..<9).hasMatches(over: [5]))
		XCTAssert((1..<9).hasMatches(over: [8]))
		XCTAssert(!(1..<9).hasMatches(over: [0]))
		XCTAssert(!(1..<9).hasMatches(over: [9]))
		XCTAssert(!(1..<9).hasMatches(over: []))
		XCTAssert(!(1..<9).hasMatches(over: [4, 5]))
		
		XCTAssert((1..<9).hasMatches(over: [1], direction: .backward))
		XCTAssert((1..<9).hasMatches(over: [5], direction: .backward))
		XCTAssert((1..<9).hasMatches(over: [8], direction: .backward))
		XCTAssert(!(1..<9).hasMatches(over: [0], direction: .backward))
		XCTAssert(!(1..<9).hasMatches(over: [9], direction: .backward))
		XCTAssert(!(1..<9).hasMatches(over: [], direction: .backward))
		XCTAssert(!(1..<9).hasMatches(over: [4, 5], direction: .backward))
		
	}
	
	func testClosedRange() {
		
		XCTAssert((1...9).hasMatches(over: [1]))
		XCTAssert((1...9).hasMatches(over: [5]))
		XCTAssert((1...9).hasMatches(over: [9]))
		XCTAssert(!(1...9).hasMatches(over: [0]))
		XCTAssert(!(1...9).hasMatches(over: [10]))
		XCTAssert(!(1...9).hasMatches(over: []))
		XCTAssert(!(1...9).hasMatches(over: [4, 5]))
		
		XCTAssert((1...9).hasMatches(over: [1], direction: .backward))
		XCTAssert((1...9).hasMatches(over: [5], direction: .backward))
		XCTAssert((1...9).hasMatches(over: [9], direction: .backward))
		XCTAssert(!(1...9).hasMatches(over: [0], direction: .backward))
		XCTAssert(!(1...9).hasMatches(over: [10], direction: .backward))
		XCTAssert(!(1...9).hasMatches(over: [], direction: .backward))
		XCTAssert(!(1...9).hasMatches(over: [4, 5], direction: .backward))
		
	}
	
	func testUnicodeScalar() {
		
		let pattern = "a"..."z" as RangePattern<String.UnicodeScalarView>
		
		XCTAssert(pattern.hasMatches(over: "a".unicodeScalars))
		XCTAssert(pattern.hasMatches(over: "q".unicodeScalars))
		XCTAssert(pattern.hasMatches(over: "z".unicodeScalars))
		XCTAssert(!pattern.hasMatches(over: "A".unicodeScalars))
		
		XCTAssert(pattern.hasMatches(over: "a".unicodeScalars, direction: .backward))
		XCTAssert(pattern.hasMatches(over: "q".unicodeScalars, direction: .backward))
		XCTAssert(pattern.hasMatches(over: "z".unicodeScalars, direction: .backward))
		XCTAssert(!pattern.hasMatches(over: "A".unicodeScalars, direction: .backward))
		
	}
	
}
