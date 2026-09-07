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
        .library(name: "Cyclic Standard Library Integration", targets: ["Cyclic Standard Library Integration"]),
        .library(name: "Cyclic Foundation Library Integration", targets: ["Cyclic Foundation Library Integration"]),
        .library(name: "Cyclic Test Support", targets: ["Cyclic Test Support"]),
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
            name: "Cyclic",
            dependencies: [
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ],
            path: "Sources/Cyclic"
        ),
        .target(
            name: "Cyclic Standard Library Integration",
            dependencies: [
                .target(name: "Cyclic"),
            ],
            path: "Sources/Cyclic Standard Library Integration"
        ),
        .target(
            name: "Cyclic Foundation Library Integration",
            dependencies: [
                .target(name: "Cyclic"),
                .target(name: "Cyclic Standard Library Integration"),
            ],
            path: "Sources/Cyclic Foundation Library Integration"
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
                .product(name: "Cardinal Standard Library Integration", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Standard Library Integration", package: "swift-ordinal"),
                .target(name: "Cyclic Standard Library Integration"),
                .target(name: "Cyclic Foundation Library Integration"),
            ],
            path: "Tests/Cyclic Tests"
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
