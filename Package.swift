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
    traits: [
        .trait(name: "Index", description: "Index integration", enabledTraits: ["Tagged"]),
        .trait(name: "Tagged", description: "Tagged integration"),
        .trait(name: "Iterator", description: "Iterator integration"),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-index.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-difference.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-sequence.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-iterator.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),


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
        .testTarget(
            name: "Absorbed swift-cyclic-index Tests",
            dependencies: [
                .product(name: "Cardinal", package: "swift-cardinal", condition: .when(traits: ["Index"])),
                .product(name: "Difference", package: "swift-difference", condition: .when(traits: ["Index"])),
                .product(name: "Index", package: "swift-index", condition: .when(traits: ["Index"])),
                .product(name: "Ordinal", package: "swift-ordinal", condition: .when(traits: ["Index"])),
                .product(name: "Tagged", package: "swift-tagged", condition: .when(traits: ["Index"])),
                .target(name: "Cyclic", condition: .when(traits: ["Index"])),
            ],
            path: "Tests/Absorbed swift-cyclic-index Tests",
            resources: [.copy("Fixtures")]
        ),
        .target(
            name: "Cyclic",
            dependencies: [
                .product(name: "Difference", package: "swift-difference", condition: .when(traits: ["Index"])),
                .product(name: "Index", package: "swift-index", condition: .when(traits: ["Index"])),
                .product(name: "Sequence", package: "swift-sequence", condition: .when(traits: ["Iterator"])),
                .product(name: "Iterator", package: "swift-iterator", condition: .when(traits: ["Iterator"])),
                .product(name: "Tagged", package: "swift-tagged", condition: .when(traits: ["Tagged"])),
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
            name: "Cyclic Tagged Tests",
            dependencies: [
                .target(name: "Cyclic"),
                .target(name: "Cyclic Test Support"),
                .product(name: "Ordinal", package: "swift-ordinal", condition: .when(traits: ["Tagged"])),
                .product(name: "Tagged", package: "swift-tagged", condition: .when(traits: ["Tagged"])),
            ],
            path: "Tests/Cyclic Tagged Tests"
        ),
        .testTarget(
            name: "Cyclic Iterator Tests",
            dependencies: [
                .target(name: "Cyclic"),
                .target(name: "Cyclic Test Support"),
                .product(name: "Cardinal", package: "swift-cardinal", condition: .when(traits: ["Iterator"])),
                .product(name: "Iterator", package: "swift-iterator", condition: .when(traits: ["Iterator"])),
                .product(name: "Ordinal", package: "swift-ordinal", condition: .when(traits: ["Iterator"])),
                .product(name: "Sequence", package: "swift-sequence", condition: .when(traits: ["Iterator"])),
            ],
            path: "Tests/Cyclic Iterator Tests"
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
