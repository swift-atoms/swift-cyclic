# Cyclic

Modular-arithmetic cyclic group types with dynamic and compile-time moduli.
Positions remain typed as `Ordinal`, while dynamic moduli and static orders use
`Cardinal`.

## Quick Start

```swift
import Cardinal
import Cyclic
import Cyclic_Group
import Cyclic_Group_Static_Element
import Ordinal

let capacity = try Cyclic::Cyclic.Group.Modulus(Cardinal::Cardinal(4))
var head = Cyclic::Cyclic.Group.Element.zero
head = Cyclic::Cyclic.Group.successor(head, modulus: capacity)

var tail = Cyclic::Cyclic.Group.Static<4>.Element.zero
tail += .one
```

`Cyclic.Group.Element` stores only its typed residue; a container supplies the
dynamic modulus for each operation. `Cyclic.Group.Static<N>.Element` carries the
modulus in its type and cannot be mixed with elements from another static group.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-atoms/swift-cyclic.git", branch: "main"),
]
```

Depend explicitly on the focused products used by a target:

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Cyclic", package: "swift-cyclic"),
        .product(name: "Cyclic Group", package: "swift-cyclic"),
        .product(name: "Cyclic Group Static Element", package: "swift-cyclic"),
    ]
)
```

## Architecture

| Product | Purpose |
| --- | --- |
| `Cyclic` | Declaration-owning base containing `Cyclic` and `Cyclic.Group`; no re-exports. |
| `Cyclic Group` | Dynamic `Element`, `Modulus`, and modular operations. |
| `Cyclic Group Static` | Compile-time-modulus `Cyclic.Group.Static<N>`. |
| `Cyclic Group Static Element` | Static `Element`, validation, and modular arithmetic. |
| `Cyclic Test Support` | Integer-literal support for static elements in tests. |

The atom depends in production only on focused Cardinal and Ordinal products.
Hash, Tagged, and Index behavior lives in the one-way molecules
[`swift-cyclic-hash`](https://github.com/swift-molecules/swift-cyclic-hash),
[`swift-cyclic-tagged`](https://github.com/swift-molecules/swift-cyclic-tagged),
and [`swift-cyclic-index`](https://github.com/swift-molecules/swift-cyclic-index).

Foundation-free. Requires Swift 6.4.

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
