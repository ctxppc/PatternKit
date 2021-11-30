// PatternKit © 2017–21 Constantino Tsarouhas

import XCTest
import PatternKitCore
@testable import PatternKitBundle

class PracticalTestCase : XCTestCase {
	
	func testEmailAddress() {
		
		let alphanumeric = ("a"..."z") | ("A"..."Z") | ("0"..."9")
		let identifierChars = alphanumeric | "_" | "+" | "-" | "."
		let user = Token(alphanumeric • identifierChars+)
		
		let domainElement = alphanumeric+
		let domain = Token((domainElement • ".")+ • domainElement)
		
		let address = user • "@" • domain
		
		guard let match = address.matches(over: "john.appleseed@here.eu").first else { return XCTFail("No match") }
		XCTAssert(match.captures(for: user) == ["john.appleseed"], "Wrong matches for user")
		XCTAssert(match.captures(for: domain) == ["here.eu"], "Wrong matches for domain")
		
	}
	
}
