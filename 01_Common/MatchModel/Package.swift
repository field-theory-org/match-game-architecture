// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "MatchModel",
    platforms: [
        .macOS(.v10_14), .iOS(.v13)
    ],
    products: [
        .library(
            name: "MatchModel",
            targets: ["MatchModel"])
    ],
    targets: [
        .target(
            name: "MatchModel",
            dependencies: [],
            exclude: ["../../README.md"]),
        .testTarget(
            name: "MatchModelTests",
            dependencies: ["MatchModel"])
    ]
)
