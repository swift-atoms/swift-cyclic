public import Cardinal
public import Index
internal import Ordinal

extension Cyclic.Group {

    @inlinable
    public static func successor(_ element: Element, modulus: Modulus) -> Element {
        let sum = element.residue + Cardinal.one
        let reduced = sum % modulus.value
        return Element(__unchecked: reduced)
    }

    @inlinable
    public static func predecessor(_ element: Element, modulus: Modulus) -> Element {

        let sum = element.residue + modulus.value.subtract.saturating(Cardinal.one)
        let reduced = sum % modulus.value
        return Element(__unchecked: reduced)
    }

    @inlinable
    public static func add(_ lhs: Element, _ rhs: Element, modulus: Modulus) -> Element {
        let sum = lhs.residue + Cardinal(rhs.residue)
        let reduced = sum % modulus.value
        return Element(__unchecked: reduced)
    }

    @inlinable
    public static func subtract(_ lhs: Element, _ rhs: Element, modulus: Modulus) -> Element {

        let inverse = modulus.value.subtract.saturating(Cardinal(rhs.residue))
        let sum = lhs.residue + inverse
        let reduced = sum % modulus.value
        return Element(__unchecked: reduced)
    }

    @inlinable
    public static func inverse(_ element: Element, modulus: Modulus) -> Element {
        if element.residue == .zero { return element }
        let inv = modulus.value.subtract.saturating(Cardinal(element.residue))
        return Element(__unchecked: Ordinal(inv))
    }

    @inlinable
    public static func advanced<Tag: ~Copyable & ~Escapable>(
        _ element: Element,
        by offset: Index<Tag>.Offset,
        modulus: Modulus
    ) -> Element {
        guard offset.vector >= .zero else {
            let backward = Ordinal(offset.magnitude.cardinal) % modulus.value
            let inverse = modulus.value.subtract.saturating(Cardinal(backward))
            let sum = element.residue + inverse
            return Element(__unchecked: sum % modulus.value)
        }

        let forward = try! Ordinal(offset.vector) % modulus.value
        let sum = element.residue + Cardinal(forward)
        return Element(__unchecked: sum % modulus.value)
    }
}
