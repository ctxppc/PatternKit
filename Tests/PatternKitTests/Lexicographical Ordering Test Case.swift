// PatternKit © 2017 Constantino Tsarouhas

import XCTest
@testable import PatternKit

class LexicographicalOrderingTestCase : XCTestCase {
	
	func testZeroElements() {
		XCTAssert(![].lexicographicallyPrecedes([Int](), orderingShorterSequencesAfter: ()))
		XCTAssert(![].lexicographicallyPrecedes([1], orderingShorterSequencesAfter: ()))
		XCTAssert(![].lexicographicallyPrecedes([1, 2], orderingShorterSequencesAfter: ()))
		XCTAssert(![].lexicographicallyPrecedes([1, 1], orderingShorterSequencesAfter: ()))
	}
	
	func testOneElement() {
		XCTAssert([1].lexicographicallyPrecedes([], orderingShorterSequencesAfter: ()))
		XCTAssert([1].lexicographicallyPrecedes([2], orderingShorterSequencesAfter: ()))
		XCTAssert(![2].lexicographicallyPrecedes([1, 2], orderingShorterSequencesAfter: ()))
		XCTAssert(![2].lexicographicallyPrecedes([2, 1], orderingShorterSequencesAfter: ()))
	}
	
	func testThreeElements() {
		XCTAssert([1, 2, 3].lexicographicallyPrecedes([1, 2, 4], orderingShorterSequencesAfter: ()))
		XCTAssert(![1, 2, 3].lexicographicallyPrecedes([1, 2, 3, 1], orderingShorterSequencesAfter: ()))
		XCTAssert([1, 2, 3].lexicographicallyPrecedes([1, 2], orderingShorterSequencesAfter: ()))
		XCTAssert([1, 2, 3].lexicographicallyPrecedes([1], orderingShorterSequencesAfter: ()))
		XCTAssert([1, 2, 3].lexicographicallyPrecedes([2], orderingShorterSequencesAfter: ()))
		XCTAssert([1, 2, 3].lexicographicallyPrecedes([2, 3], orderingShorterSequencesAfter: ()))
		XCTAssert([1, 2, 3].lexicographicallyPrecedes([1, 3], orderingShorterSequencesAfter: ()))
		XCTAssert([1, 2, 3].lexicographicallyPrecedes([], orderingShorterSequencesAfter: ()))
		XCTAssert(![1, 2, 3].lexicographicallyPrecedes([1, 2, 2], orderingShorterSequencesAfter: ()))
	}
	
}
