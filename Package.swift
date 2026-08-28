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
            url: "https://github.com/swift-atoms/swift-ordinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Cyclic"
        ),

        .target(
            name: "Cyclic Group Static",
            dependencies: [
                .target(name: "Cyclic")
            ]
        ),

        .target(
            name: "Cyclic Group Static Element",
            dependencies: [
                .target(name: "Cyclic"),
                .target(name: "Cyclic Group Static"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),

        .target(
            name: "Cyclic Group",
            dependencies: [
                .target(name: "Cyclic"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),

        .target(
            name: "Cyclic Test Support",
            dependencies: [
                .target(name: "Cyclic"),
                .target(name: "Cyclic Group Static"),
                .target(name: "Cyclic Group Static Element"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Cyclic Tests",
            dependencies: [
                .target(name: "Cyclic"),
                .target(name: "Cyclic Group"),
                .target(name: "Cyclic Group Static"),
                .target(name: "Cyclic Group Static Element"),
                .target(name: "Cyclic Test Support"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(
                    name: "Cardinal Standard Library Integration",
                    package: "swift-cardinal"
                ),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(
                    name: "Ordinal Standard Library Integration",
                    package: "swift-ordinal"
                ),
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
