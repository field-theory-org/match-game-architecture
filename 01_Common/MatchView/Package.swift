// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MatchView",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MatchView",
            targets: ["MatchView"])
    ],
    targets: [
        .target(
            name: "MatchView",
            dependencies: [],
            exclude: ["../../README.md"])
    ]
)
