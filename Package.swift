// swift-tools-version:5.5
// PatternKit © 2017–21 Constantino Tsarouhas

import PackageDescription

let package = Package(
    name: "PatternKit",
	products: [
		
		// The PatternKit library includes the full suite. This product is suitable for applications that use strongly typed patterns and/or regular expressions.
		.library(name: "PatternKit", targets: ["PatternKitCore", "PatternKitBundle", "PatternKitRegex"]),
		
		// The Basic library contains the primitive types from which all kinds of patterns can be defined. This product is suitable for libraries and applications that define new pattern types and don't depend on predefined pattern types.
		.library(name: "PatternKitBasic", targets: ["PatternKitCore"]),
		
		// The Static library contains the PatternKit suite without regular expression support. This product is suitable for applications that use PatternKit for matching over subjects that are not strings or for patterns defined at compile-time only.
		.library(name: "PatternKitStatic", targets: ["PatternKitCore", "PatternKitBundle"]),
		
	],
	dependencies: [
		.package(url: "https://github.com/ctxppc/DepthKit.git", from: "0.10.0")
	],
	targets: [
		
		// The Core target contains primitive types from which all kinds of patterns can be defined.
		.target(name: "PatternKitCore", dependencies: ["DepthKit"], path: "Sources/Core"),
		
		// The Bundle target contains a set of concrete Pattern types.
		.target(name: "PatternKitBundle", dependencies: ["DepthKit", "PatternKitCore"], path: "Sources/Bundle"),
		.testTarget(name: "PatternKitBundle Tests", dependencies: ["PatternKitBundle"], path: "Tests/Bundle"),
		
		// The Regex target extends PatternKit with regular expression support.
		.target(name: "PatternKitRegex", dependencies: ["DepthKit", "PatternKitCore", "PatternKitBundle"], path: "Sources/Regex"),
		.testTarget(name: "PatternKitRegex Tests", dependencies: ["PatternKitRegex"], path: "Tests/Regex")
		
	],
	swiftLanguageVersions: [.v4, .v4_2, .v5]
)
