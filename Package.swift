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
        .library(name: "Cyclic", targets: ["Cyclic"]),

        .library(name: "Cyclic Foundation Integration", targets: ["Cyclic Foundation Integration"]),
        .library(name: "Cyclic Test Support", targets: ["Cyclic Test Support"]),
    ],
    dependencies: [

        .package(url: "https://github.com/swift-atoms/swift-hash.git", branch: "main"),

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
            name: "Cyclic",
            dependencies: [
                .product(name: "Hash", package: "swift-hash"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ],
            path: "Sources/Cyclic"
        ),
        
        .target(
            name: "Cyclic Foundation Integration",
            dependencies: [
                .target(name: "Cyclic"),
            ],
            path: "Sources/Cyclic Foundation Integration"
        ),
        .target(
            name: "Cyclic Test Support",
            dependencies: [
                .target(name: "Cyclic"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Cyclic Tests",
            dependencies: [
                .target(name: "Cyclic"),
                .target(name: "Cyclic Test Support"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .target(name: "Cyclic Foundation Integration"),
            ],
            path: "Tests/Cyclic Tests"
        ),
        .testTarget(
            name: "Consolidated Cyclic Hash Tests",
            dependencies: [

                .target(name: "Cyclic"),
                .product(name: "Hash", package: "swift-hash"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ],
            path: "Tests/Consolidated swift-cyclic-hash"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
