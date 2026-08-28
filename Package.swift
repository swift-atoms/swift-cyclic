// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-cyclic",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(
            name: "Cyclic Group",
            targets: ["Cyclic Group"]
        ),
        .library(
            name: "Cyclic Group Static Element",
            targets: ["Cyclic Group Static Element"]
        ),
        .library(
            name: "Cyclic Group Static",
            targets: ["Cyclic Group Static"]
        ),
        .library(
            name: "Cyclic Namespace",
            targets: ["Cyclic Namespace"]
        ),
        .library(
            name: "Cyclic Standard Library Integration",
            targets: ["Cyclic Standard Library Integration"]
        ),
        .library(
            name: "Cyclic Tagged Integration",
            targets: ["Cyclic Tagged Integration"]
        ),

        .library(
            name: "Cyclic",
            targets: ["Cyclic"]
        ),

        .library(
            name: "Cyclic Test Support",
            targets: ["Cyclic Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-comparison.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-hash.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ordinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-index.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Cyclic Namespace"
        ),

        .target(
            name: "Cyclic Group Static",
            dependencies: [
                .target(name: "Cyclic Namespace")
            ]
        ),

        .target(
            name: "Cyclic Group Static Element",
            dependencies: [
                .target(name: "Cyclic Group Static"),
                .target(name: "Cyclic Namespace"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),

        .target(
            name: "Cyclic Group",
            dependencies: [
                .target(name: "Cyclic Namespace"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),

        .target(
            name: "Cyclic Standard Library Integration",
            dependencies: [
                .target(name: "Cyclic Group Static Element"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Hash", package: "swift-hash"),
            ]
        ),

        .target(
            name: "Cyclic Tagged Integration",
            dependencies: [
                .target(name: "Cyclic Group Static Element"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),

        .target(
            name: "Cyclic",
            dependencies: [
                .target(name: "Cyclic Group"),
                .target(name: "Cyclic Group Static Element"),
                .target(name: "Cyclic Group Static"),
                .target(name: "Cyclic Namespace"),
                .target(name: "Cyclic Standard Library Integration"),
                .target(name: "Cyclic Tagged Integration"),
            ]
        ),

        .target(
            name: "Cyclic Test Support",
            dependencies: [.target(name: "Cyclic")],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Cyclic Tests",
            dependencies: [
                .target(name: "Cyclic"),
                .target(name: "Cyclic Test Support"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
