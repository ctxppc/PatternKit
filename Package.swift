// swift-tools-version:4.0
// PatternKit © 2017 Constantino Tsarouhas

import PackageDescription

let package = Package(
    name: "PatternKit",
	products: [
		.library(name: "PatternKit", targets: ["PatternKit"])
	],
	dependencies: [
		.package(url: "https://github.com/ctxppc/DepthKit.git", from: "0.1.1")
	],
	targets: [
		.target(name: "PatternKit", dependencies: ["DepthKit"], path: "Sources"),
		.testTarget(name: "PatternKit Tests", dependencies: ["PatternKit"], path: "Tests")
	],
	swiftLanguageVersions: [4]
)
