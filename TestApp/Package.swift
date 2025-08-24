// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "RichTextTestApp",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .executable(name: "RichTextTestApp", targets: ["RichTextTestApp"])
    ],
    dependencies: [
        .package(path: "../")
    ],
    targets: [
        .executableTarget(
            name: "RichTextTestApp",
            dependencies: ["RichText"],
            path: ".",
            resources: [.copy("README.md")]
        )
    ]
)
