// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cipher",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.4"),
        .package(url: "https://github.com/RNCryptor/RNCryptor.git", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "cipher",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "RNCryptor", package: "RNCryptor")
            ]),
        .testTarget(
            name: "cipherTests",
            dependencies: ["cipher"]),
    ]
)
