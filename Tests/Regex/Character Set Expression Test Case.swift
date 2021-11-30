// PatternKit © 2017–21 Constantino Tsarouhas

import XCTest
@testable import PatternKitRegex

class CharacterSetExpressionTestCase : XCTestCase {
	
	func testInclusiveEmpty() {
		let expression = CharacterSetExpression([])
		let serialisation = "[]"
		XCTAssert(try! expression.serialisation(language: .ecmaScript) == serialisation)
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == serialisation)
	}
	
	func testInclusiveSingletons() {
		let expression = CharacterSetExpression(["a", "e", "i", "o", "u"])
		let serialisation = "[aeiou]"
		XCTAssert(try! expression.serialisation(language: .ecmaScript) == serialisation)
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == serialisation)
	}
	
	func testInclusiveRanges() {
		let expression = CharacterSetExpression(["a"..."e", "i"..."o"])
		let serialisation = "[a-ei-o]"
		XCTAssert(try! expression.serialisation(language: .ecmaScript) == serialisation)
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == serialisation)
	}
	
	func testInclusiveMixed() {
		
		let leadingSingletonExpression = CharacterSetExpression(["u", "a"..."e", "i"..."o"])
		let leadingSingletonSerialisation = "[ua-ei-o]"
		XCTAssert(try! leadingSingletonExpression.serialisation(language: .ecmaScript) == leadingSingletonSerialisation)
		XCTAssert(try! leadingSingletonExpression.serialisation(language: .perlCompatibleREs) == leadingSingletonSerialisation)
		
		let middleSingletonExpression = CharacterSetExpression(["a"..."e", "u", "i"..."o"])
		let middleSingletonSerialisation = "[a-eui-o]"
		XCTAssert(try! middleSingletonExpression.serialisation(language: .ecmaScript) == middleSingletonSerialisation)
		XCTAssert(try! middleSingletonExpression.serialisation(language: .perlCompatibleREs) == middleSingletonSerialisation)
		
		let trailingSingletonExpression = CharacterSetExpression(["a"..."e", "i"..."o", "u"])
		let trailingSingletonSerialisation = "[a-ei-ou]"
		XCTAssert(try! trailingSingletonExpression.serialisation(language: .ecmaScript) == trailingSingletonSerialisation)
		XCTAssert(try! trailingSingletonExpression.serialisation(language: .perlCompatibleREs) == trailingSingletonSerialisation)
		
	}
	
	func testExclusiveEmpty() {
		let expression = CharacterSetExpression([], membership: .exclusive)
		let serialisation = "[^]"
		XCTAssert(try! expression.serialisation(language: .ecmaScript) == serialisation)
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == serialisation)
	}
	
	func testExclusiveSingletons() {
		let expression = CharacterSetExpression(["a", "e", "i", "o", "u"], membership: .exclusive)
		let serialisation = "[^aeiou]"
		XCTAssert(try! expression.serialisation(language: .ecmaScript) == serialisation)
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == serialisation)
	}
	
	func testExclusiveRanges() {
		let expression = CharacterSetExpression(["a"..."e", "i"..."o"], membership: .exclusive)
		let serialisation = "[^a-ei-o]"
		XCTAssert(try! expression.serialisation(language: .ecmaScript) == serialisation)
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == serialisation)
	}
	
	func testExclusiveMixed() {
		
		let leadingSingletonExpression = CharacterSetExpression(["u", "a"..."e", "i"..."o"], membership: .exclusive)
		let leadingSingletonSerialisation = "[^ua-ei-o]"
		XCTAssert(try! leadingSingletonExpression.serialisation(language: .ecmaScript) == leadingSingletonSerialisation)
		XCTAssert(try! leadingSingletonExpression.serialisation(language: .perlCompatibleREs) == leadingSingletonSerialisation)
		
		let middleSingletonExpression = CharacterSetExpression(["a"..."e", "u", "i"..."o"], membership: .exclusive)
		let middleSingletonSerialisation = "[^a-eui-o]"
		XCTAssert(try! middleSingletonExpression.serialisation(language: .ecmaScript) == middleSingletonSerialisation)
		XCTAssert(try! middleSingletonExpression.serialisation(language: .perlCompatibleREs) == middleSingletonSerialisation)
		
		let trailingSingletonExpression = CharacterSetExpression(["a"..."e", "i"..."o", "u"], membership: .exclusive)
		let trailingSingletonSerialisation = "[^a-ei-ou]"
		XCTAssert(try! trailingSingletonExpression.serialisation(language: .ecmaScript) == trailingSingletonSerialisation)
		XCTAssert(try! trailingSingletonExpression.serialisation(language: .perlCompatibleREs) == trailingSingletonSerialisation)
		
	}
	
	func testClosingBracket() {
		let expression = CharacterSetExpression(["a"..."e", "i"..."o", "]"])
		let serialisation = "[a-ei-o\\]]"
		XCTAssert(try! expression.serialisation(language: .ecmaScript) == serialisation)
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == serialisation)
	}
	
	func testInclusiveCaret() {
		let expression = CharacterSetExpression(["^", "a"..."e", "i"..."o", "^"])
		let serialisation = "[\\^a-ei-o^]"
		XCTAssert(try! expression.serialisation(language: .ecmaScript) == serialisation)
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == serialisation)
	}
	
	func testExclusiveCaret() {
		let expression = CharacterSetExpression(["^", "a"..."e", "i"..."o", "^"], membership: .exclusive)
		let serialisation = "[^^a-ei-o^]"
		XCTAssert(try! expression.serialisation(language: .ecmaScript) == serialisation)
		XCTAssert(try! expression.serialisation(language: .perlCompatibleREs) == serialisation)
	}
	
}
