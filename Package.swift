// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
//
//let swiftSettings: [SwiftSetting] = [
//   .enableUpcomingFeature("BareSlashRegexLiterals"),
//   .enableUpcomingFeature("ConciseMagicFile"),
//   .enableUpcomingFeature("ExistentialAny"),
//   .enableUpcomingFeature("ForwardTrailingClosures"),
//   .enableUpcomingFeature("ImplicitOpenExistentials"),
//   .enableUpcomingFeature("StrictConcurrency"),
//   .unsafeFlags(["-warn-concurrency", "-enable-actor-data-race-checks"]),
//]

let package = Package(
    name: "NetworkService",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NetworkService",
            targets: ["NetworkService"]),
        
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NetworkService"
        ),
        .testTarget(
            name: "NetworkServiceTests",
            dependencies: ["NetworkService"]),
    ]
)
