// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RichText",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "RichText",
            targets: ["RichText"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RichText",
            dependencies: [],
            resources: [
                .copy("PrivacyInfo.xcprivacy")
            ]),
        .testTarget(
            name: "RichTextTests",
            dependencies: ["RichText"]
        ),
    ]
)
