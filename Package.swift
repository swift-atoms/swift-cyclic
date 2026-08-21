// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-cyclic-primitives",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(
            name: "Cyclic Group Primitives",
            targets: ["Cyclic Group Primitives"]
        ),
        .library(
            name: "Cyclic Group Static Element Primitives",
            targets: ["Cyclic Group Static Element Primitives"]
        ),
        .library(
            name: "Cyclic Group Static Primitives",
            targets: ["Cyclic Group Static Primitives"]
        ),
        .library(
            name: "Cyclic Namespace Primitives",
            targets: ["Cyclic Namespace Primitives"]
        ),
        .library(
            name: "Cyclic Primitives Standard Library Integration",
            targets: ["Cyclic Primitives Standard Library Integration"]
        ),
        .library(
            name: "Cyclic Primitives Tagged Integration",
            targets: ["Cyclic Primitives Tagged Integration"]
        ),

        .library(
            name: "Cyclic Primitives",
            targets: ["Cyclic Primitives"]
        ),

        .library(
            name: "Cyclic Primitives Test Support",
            targets: ["Cyclic Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-comparison-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-hash-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-tagged-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-ordinal-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-cardinal-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-index-primitives.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Cyclic Namespace Primitives"
        ),

        .target(
            name: "Cyclic Group Static Primitives",
            dependencies: [
                "Cyclic Namespace Primitives"
            ]
        ),

        .target(
            name: "Cyclic Group Static Element Primitives",
            dependencies: [
                "Cyclic Group Static Primitives",
                "Cyclic Namespace Primitives",
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
            ]
        ),

        .target(
            name: "Cyclic Group Primitives",
            dependencies: [
                "Cyclic Namespace Primitives",
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Index Primitives", package: "swift-index-primitives"),
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
            ]
        ),

        .target(
            name: "Cyclic Primitives Standard Library Integration",
            dependencies: [
                "Cyclic Group Static Element Primitives",
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
                .product(name: "Hash Primitives", package: "swift-hash-primitives"),
            ]
        ),

        .target(
            name: "Cyclic Primitives Tagged Integration",
            dependencies: [
                "Cyclic Group Static Element Primitives",
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),

        .target(
            name: "Cyclic Primitives",
            dependencies: [
                "Cyclic Group Primitives",
                "Cyclic Group Static Element Primitives",
                "Cyclic Group Static Primitives",
                "Cyclic Namespace Primitives",
                "Cyclic Primitives Standard Library Integration",
                "Cyclic Primitives Tagged Integration",
            ]
        ),

        .target(
            name: "Cyclic Primitives Test Support",
            dependencies: ["Cyclic Primitives"],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Cyclic Primitives Tests",
            dependencies: [
                "Cyclic Primitives",
                "Cyclic Primitives Test Support",
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
