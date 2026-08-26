# Cyclic

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Modular-arithmetic cyclic group types — both a dynamic-modulus surface (`Cyclic.Group.Element` + `Cyclic.Group.Modulus`) where the modulus is container-owned, and a compile-time-modulus specialization (`Cyclic.Group.Static<let N: Int>.Element`) where the modulus is a value generic and the element type is zero-sized.

Cyclic groups ℤ/nℤ are the algebraic structure behind ring-buffer indices, circular navigation, modular arithmetic, and any wrap-around counting domain. This package separates the dynamic and static surfaces so consumers can pick the lifecycle that matches their data: a runtime-configured ring buffer reaches for `Cyclic.Group.Element` + `Modulus`; a known-capacity buffer reaches for `Cyclic.Group.Static<N>.Element`.

This package is part of **Story 2 of the data-structures cohort** (`data-structures-launch-2026`): seven packages introducing typed indexing and sequences — order, index, sequence, collection, input, **cyclic**, vector. Story 1 (cardinal, ordinal, affine) shipped 2026-05-12; Story 2 Wave 1 (order + index) shipped 2026-05-13; Wave 2 Package 3 (sequence) shipped 2026-05-16. Cyclic depends on cardinal (for counts), ordinal (for positions), index (for `Index<Tag>` and `Index<Tag>.Offset`), and sequence (for the iterator protocol family).

---

## Quick Start

```swift
import Cyclic

// Compile-time modulus — zero-sized element type, no runtime modulus storage
var tail: Cyclic.Group.Static<4>.Element = .zero
tail += .one  // 1
tail += .one  // 2
tail += .one  // 3
tail += .one  // 0 (wraps)

// Iterate every element of the group
for element in Cyclic.Group.Static<5>() {
    print(element.position)  // 0, 1, 2, 3, 4
}

// Dynamic modulus — element stores only the residue; container supplies modulus
let capacity = try Cyclic.Group.Modulus(Cardinal(4))
var head = Cyclic.Group.Element.zero
head = Cyclic.Group.successor(head, modulus: capacity)  // 1
head = Cyclic.Group.successor(head, modulus: capacity)  // 2
```

The dual surface is the package's reason to exist as L1. `Cyclic.Group.Static<N>` is the right tool when capacity is fixed at compile time — every element of `Cyclic.Group.Static<4>` is exactly the same zero-sized type; the modulus never appears in storage. `Cyclic.Group.Element` + `Modulus` is the right tool when the capacity is owned by a container (a ring buffer with runtime-configurable size); storing the modulus per element would waste memory across thousands of elements that share one container.

---

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-molecules/swift-cyclic.git", branch: "main"),
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Cyclic", package: "swift-cyclic"),
    ]
)
```

The package is pre-1.0 — until 0.1.0 is tagged, depend on `branch: "main"` rather than `from: "0.1.0"`. Requires Swift 6.3.1 (for value generic parameters `<let N: Int>`) and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Eight library products: an umbrella, six subject-domain sub-products, and a Test Support spine.

| Product | Target | Purpose |
|---------|--------|---------|
| `Cyclic` | `Sources/Cyclic/` | Umbrella that re-exports every sub-product below. The dynamic surface (`Cyclic.Group.Element`, `Cyclic.Group.Modulus`, free-function operations), the static surface (`Cyclic.Group.Static<let N: Int>`, its `Element` + `Element.Error`, `Iterator`), `Tagged<Tag, Cyclic.Group.Static<N>.Element>` arithmetic, and an `Ordinal(_:)` conversion from a static element. The package re-exports `Cardinal`, `Comparison`, `Hash`, `Index`, `Ordinal`, `Sequence`, and `Tagged` so a single `import Cyclic` brings the full surface into scope. |
| `Cyclic Group` | `Sources/Cyclic Group/` | The dynamic surface: `Cyclic.Group.Element`, `Cyclic.Group.Modulus`, and free-function operations. |
| `Cyclic Group Static` | `Sources/Cyclic Group Static/` | The static surface: `Cyclic.Group.Static<let N: Int>`. |
| `Cyclic Group Static Element` | `Sources/Cyclic Group Static Element/` | `Cyclic.Group.Static<N>.Element`, its `Element.Error`, and its `Iterator`. |
| `Cyclic Namespace` | `Sources/Cyclic Namespace/` | The shared `Cyclic` namespace enum. |
| `Cyclic Standard Library Integration` | `Sources/Cyclic Standard Library Integration/` | The `Ordinal(_:)` conversion from a static element and other stdlib bridges. |
| `Cyclic Tagged Integration` | `Sources/Cyclic Tagged Integration/` | `Tagged<Tag, Cyclic.Group.Static<N>.Element>` arithmetic. |
| `Cyclic Test Support` | `Tests/Support/` | An `ExpressibleByIntegerLiteral` conformance for `Cyclic.Group.Static<N>.Element` so test sites can write `let a: Cyclic.Group.Static<5>.Element = 3` rather than `try! .init(Ordinal(3))`. Trapping; production code uses the throwing `init(_:)`. |

`Cyclic` is the supported default for consumer code; the six subject-domain products above are implementation details that back the umbrella and exist to keep a narrow dependency available. `Cyclic Test Support` is the only other product intended for direct import, and only from test targets.

Foundation-free. No platform conditionals.

### Why two surfaces?

The dual surface reflects two distinct lifecycle patterns for cyclic groups:

**Container-owned modulus (dynamic).** A ring buffer's capacity is configured at runtime — `Cyclic.Group.Element` stores only the residue (an `Ordinal`); the modulus is supplied per-operation by the container. This is the right shape when one modulus governs many elements, or when the modulus changes at runtime (resizable ring buffer).

**Compile-time modulus (static).** A fixed-capacity buffer (a hash-table-bucket index, a fixed wheel of states, a small modular ring at type-check time) — `Cyclic.Group.Static<let N: Int>` carries the modulus as a value-generic parameter. `Cyclic.Group.Static<4>.Element` is a distinct type from `Cyclic.Group.Static<8>.Element`; the compiler enforces that elements from different cyclic groups cannot be mixed. The element type is zero-sized for storage but type-distinct for arithmetic.

Both surfaces share the same algebraic structure (closure, associativity, identity, inverse over addition mod n) — they differ only in *where the modulus lives*. The package exposes both because either choice is the wrong default for some consumer.

---

## Sequence over all elements

`Cyclic.Group.Static<N>` itself conforms to both `Sequence.Protocol` (the noncopyable-element-supporting protocol family from `Sequence`) and `Swift.Sequence` (the stdlib's `Copyable`-element variant). Iterating the group produces every element in `[0, N)` exactly once:

```swift
for element in Cyclic.Group.Static<5>() {
    print(element.position)  // 0, 1, 2, 3, 4
}
```

The iterator implements `nextSpan(maximumCount:) -> Span<Element>` as its primitive method (per the `Sequence.Protocol` family contract). The Span is borrowed from the iterator's internal `InlineArray<1, Element>` storage; consume it before the next call invalidates the previous return value. `next() -> Element?` is the convenience built on top.

---

## Typed-index integration

`Cyclic.Group.Element.init<Tag: ~Copyable>(__unchecked index: Index<Tag>)` and `Cyclic.Group.Modulus.init<Tag: ~Copyable>(_ count: Index<Tag>.Count)` accept the phantom-tagged index and count types from `swift-index`. `Cyclic.Group.advanced(_:by:modulus:)` accepts an `Index<Tag>.Offset` (signed displacement, from `swift-affine` via index's re-export chain) and computes wrap-around arithmetic correctly for both positive and negative offsets.

The `Tag: ~Copyable` constraint widens the set of phantom-tag types consumers can use — including tags that wrap unique resource handles — without imposing non-copyability on the cyclic-group element itself.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |
| Linux | Full support (post-flip CI matrix) |
| Windows | Full support (post-flip CI matrix) |
| Swift Embedded | Heuristic-supported (no Foundation, no concurrency surface) — first-party Embedded matrix runs post-flip |

---

## Stability

Pre-1.0. The public API may change before 0.1.0 is tagged; consumers depending on `branch: "main"` should expect breaking changes to surface in commit messages and the audit trail under `Audits/`. Once tagged, the package follows the institute SemVer convention: post-1.0 breaking changes ship behind a major bump.

`Cyclic.Group.Static<let N: Int>` requires Swift 6.3+ for value generic parameters. The dual-surface design (dynamic + static) is the 0.1.0 shape and reflects the algebraic distinction described in [Why two surfaces?](#why-two-surfaces) — neither surface subsumes the other.

---

## Related Packages

Direct dependencies (all already-public):

- [swift-comparison](https://github.com/swift-molecules/swift-comparison) — `Comparison.Protocol`, the `Comparable`-shape conformance the element types expose.
- [swift-hash](https://github.com/swift-molecules/swift-hash) — `Hash.Protocol`, the `Hashable`-shape conformance the element types expose.
- [swift-tagged](https://github.com/swift-molecules/swift-tagged) — `Tagged<Tag, Underlying>`, the phantom-tagging machinery `Tagged<Tag, Cyclic.Group.Static<N>.Element>` is built on.
- [swift-ordinal](https://github.com/swift-molecules/swift-ordinal) — `Ordinal`, the non-negative position type both element surfaces store.
- [swift-cardinal](https://github.com/swift-molecules/swift-cardinal) — `Cardinal`, the non-negative count type `Modulus` wraps.
- [swift-index](https://github.com/swift-molecules/swift-index) — `Index<Tag>`, `Index<Tag>.Count`, `Index<Tag>.Offset`, the typed-indexing surface the public-API constructors and `advanced(_:by:modulus:)` consume.
- [swift-sequence](https://github.com/swift-molecules/swift-sequence) — `Sequence.Protocol` and `Sequence.Iterator.Protocol`, the iterator family `Cyclic.Group.Static.Iterator` conforms to.

Cohort siblings (Story 2 — Typed indexing and sequences):

- order, index, sequence, collection, input, **cyclic**, vector — see [`data-structures-launch-2026`](https://github.com/swift-institute) for the cohort narrative.

Story 1 sibling primitives ([`cardinal`](https://github.com/swift-molecules/swift-cardinal), [`ordinal`](https://github.com/swift-molecules/swift-ordinal), [`affine`](https://github.com/swift-molecules/swift-affine)) shipped 2026-05-12 and supply the counting / position / displacement primitives the dynamic and static surfaces are built on.

---

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
