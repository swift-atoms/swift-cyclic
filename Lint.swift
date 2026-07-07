// swift-linter-tools-version: 0.1
// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-cyclic-primitives open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-cyclic-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

// Shape-γ unified consumer manifest. swift-cyclic-primitives owns the
// `Cyclic.Group.Static<N>.Element` brand-newtype (Tagged-wrapped Ordinal)
// under the `Cyclic` namespace root. The boundary recognizer rules that
// fire on the owner's own same-package surface (`raw value access`,
// `unchecked call site`, `tagged extension public init`) self-suppress
// via the engine's §A brand pre-pass (`Lint.Brand.owned`) — the run
// declares `Cyclic` at namespace root — so no per-package
// `.excluding(rules:)` stopgap is needed, while cross-package strict-
// superset firing on external consumers is preserved.

import Linter
import Linter_Primitives_Rules

Lint.run(dependencies: [
    .package(
        url: "https://github.com/swift-primitives/swift-primitives-linter-rules.git",
        branch: "main",
        products: ["Linter Primitives Rules"]
    ),
]) {
    Lint.Rule.Bundle.primitives
}
