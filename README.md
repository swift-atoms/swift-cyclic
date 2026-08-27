# swift-cyclic

Modular arithmetic for runtime and compile-time cyclic groups.

`Cyclic.Group.Element` pairs with a container-owned `Cyclic.Group.Modulus` when the modulus is known at runtime. `Cyclic.Group.Static<N>.Element` carries the modulus in its type when it is known at compile time. Both surfaces normalize arithmetic without overflowing `UInt`.

## Installation

Add `swift-cyclic` to a Swift package:

```swift
dependencies: [
    .package(
        url: "https://github.com/swift-atoms/swift-cyclic.git",
        branch: "main"
    ),
]
```

Then depend on the core product:

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Cyclic", package: "swift-cyclic"),
    ]
)
```

## Runtime modulus

The dynamic element stores only its residue. The owner supplies the shared modulus to each operation:

```swift
import Cyclic

let capacity = try Cyclic.Group.Modulus(Cardinal(4))
var cursor = Cyclic.Group.Element.zero

cursor = Cyclic.Group.successor(cursor, modulus: capacity)
cursor = Cyclic.Group.advanced(cursor, by: -2, modulus: capacity)
```

An unchecked initializer accepts `Index<Tag>` when a caller has already established that the index belongs to the same modulus.

## Compile-time modulus

The static surface makes elements from different moduli different types:

```swift
import Cyclic

let start = try Cyclic.Group.Static<5>.Element(Ordinal(4))
let wrapped = start + .one
// wrapped.position == Ordinal(0)
```

The throwing initializer validates a position. `init(wrapping:)` normalizes an arbitrary `Ordinal`, and `init(__unchecked:)` is available when the caller already owns the invariant.

## Products

The package deliberately has three library products:

- `Cyclic` contains the Foundation-free core.
- `Cyclic Apple Foundation Integration` is the only target that imports Foundation.
- `Cyclic Test Support` adds a trapping integer-literal convenience for `Cyclic.Group.Static<N>.Element`; use it only from tests.

The core depends directly on the current atom homes for [swift-cardinal](https://github.com/swift-atoms/swift-cardinal), [swift-index](https://github.com/swift-atoms/swift-index), and [swift-ordinal](https://github.com/swift-atoms/swift-ordinal).

## Platform posture

The manifest targets Swift 6.4 and the current Apple platform generation. The core has no Foundation import or platform conditional. Embedded compilation is tracked separately from the normal build because it also depends on toolchain support for the standard `Swift` module.

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
