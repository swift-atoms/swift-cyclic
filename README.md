# swift-cyclic

Use this package when positions wrap around: ring-buffer heads and tails, rotations, any arithmetic in the integers modulo n. Start from `Cyclic.Group.Static<modulus>.Element` when the modulus is known at compile time, and from `Cyclic.Group.Element` with a `Cyclic.Group.Modulus` when it is only known at run time. With the `Index` trait, `Index<Tag>.Modular` performs the same wrapping on typed indices against a typed capacity, and `Index<Tag>.Cyclic<N>` is a static cyclic element that keeps its index tag.

## Laws

- Every operation is addition in the integers modulo n: results always lie in `0..<n`, `zero` is the identity, an element plus its inverse is `zero`, and the inverse of `zero` is `zero`. Results equal exact integer arithmetic reduced modulo n for every modulus up to `UInt.max`, with no intermediate overflow; this includes `Index<Tag>.Modular.physical(forLogical:head:capacity:)` and signed offsets of any magnitude, including `Int.min`.
- `Cyclic.Group.Element` does not carry its modulus. Each operation reduces its operands by the modulus passed to it, so the caller must pass the same modulus throughout. Equality, hashing and ordering compare the stored residue as is: `init(_:modulus:)` normalises it, `init(__unchecked:)` does not.
- Ordering is the numeric order of residues `0 < 1 < … < n - 1`. It is not preserved by addition: a successor can compare less than its predecessor.
- `Cyclic.Group.Static<modulus>` with a modulus of zero or less has no elements. The checked initialiser throws, while `order`, `init(wrapping:)`, `+`, `-` and `inverse` trap. With a modulus of 1, `one` equals `zero`.
- The checked initialiser of a static element rejects any position at or beyond the modulus and reports the full, unnarrowed position.
- With the Iterator trait, iterating `Cyclic.Group.Static<modulus>` yields exactly `modulus` elements, positions `0` through `modulus - 1` in ascending order.
- `Index<Tag>.Modular` traps when the capacity is zero.
