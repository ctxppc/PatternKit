// swift-tools-version:5.5
// PatternKit © 2017–21 Constantino Tsarouhas

import PackageDescription

let package = Package(
    name: "PatternKit",
	products: [
		.library(name: "PatternKit", targets: ["PatternKit"]),
		.library(name: "RegexKit", targets: ["RegexKit"]),
	],
	dependencies: [
		.package(url: "https://github.com/ctxppc/DepthKit.git", .upToNextMinor(from: "0.10.0")),
	],
	targets: [
		
		// The PatternKitCore target contains primitive types from which all kinds of patterns can be defined.
		.target(name: "PatternKitCore", dependencies: [
			.product(name: "DepthKit", package: "DepthKit"),
		]),
		
		// The PatternKit target extends PatternKitCore with a set of concrete Pattern types.
		.target(name: "PatternKit", dependencies: ["PatternKitCore"]),
		.testTarget(name: "PatternKitTests", dependencies: [
			"PatternKit",
			.product(name: "DepthKit", package: "DepthKit"),
		]),
		
		// The RegexKit target extends PatternKit with regular expression support.
		.target(name: "RegexKit", dependencies: ["PatternKit"]),
		.testTarget(name: "RegexKitTests", dependencies: [
			"RegexKit",
			.product(name: "DepthKit", package: "DepthKit"),
		])
		
	],
	swiftLanguageVersions: [.v5]
)
