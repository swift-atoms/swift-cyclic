#if Index
#if os(macOS)
import Foundation
import Testing

@Suite struct `Modular arithmetic requires matching domains` {
    @Test(arguments: ["MATCHING", "MISMATCH_OFFSET", "MISMATCH_CAPACITY"])
    func `the compiler checks both offset and capacity domains`(configuration: String) throws {
        var products = Bundle.module.bundleURL
        while !FileManager.default.fileExists(
            atPath: products.appendingPathComponent("Cyclic.swiftmodule").path
        ) {
            let parent = products.deletingLastPathComponent()
            products = try #require(parent != products ? parent : nil)
        }
        let source = try #require(Bundle.module.resourceURL)
            .appendingPathComponent("Fixtures/Modular domains.swift")
        let process = Process()
        let errors = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
        process.arguments = [
            "swiftc", "-typecheck", "-swift-version", "6",
            "-enable-experimental-feature", "Lifetimes",
            "-module-name", "Client", "-I", products.path,
            "-D", configuration, source.path,
        ]
        process.standardError = errors
        try process.run()
        let diagnostic = String(
            decoding: errors.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self
        )
        process.waitUntilExit()
        let mismatched = configuration != "MATCHING"
        #expect((process.terminationStatus != 0) == mismatched, "\(diagnostic)")
        if mismatched {
            #expect(diagnostic.contains("First") && diagnostic.contains("Second"))
        }
        #expect(!diagnostic.contains("no such module"))
    }
}
#endif
#endif
