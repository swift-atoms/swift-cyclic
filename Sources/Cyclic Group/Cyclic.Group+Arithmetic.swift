public import Cardinal
public import Cyclic
public import Ordinal

extension Cyclic::Cyclic.Group {

    @inlinable
    public static func successor(_ element: Element, modulus: Modulus) -> Element {
        let reduced = __cyclicAdd(
            element.residue.rawValue,
            1,
            modulus: modulus.value.rawValue
        )
        return Element(__unchecked: Ordinal::Ordinal(reduced))
    }

    @inlinable
    public static func predecessor(_ element: Element, modulus: Modulus) -> Element {

        let reduced = __cyclicSubtract(
            element.residue.rawValue,
            1,
            modulus: modulus.value.rawValue
        )
        return Element(__unchecked: Ordinal::Ordinal(reduced))
    }

    @inlinable
    public static func add(_ lhs: Element, _ rhs: Element, modulus: Modulus) -> Element {
        let reduced = __cyclicAdd(
            lhs.residue.rawValue,
            rhs.residue.rawValue,
            modulus: modulus.value.rawValue
        )
        return Element(__unchecked: Ordinal::Ordinal(reduced))
    }

    @inlinable
    public static func subtract(_ lhs: Element, _ rhs: Element, modulus: Modulus) -> Element {

        let reduced = __cyclicSubtract(
            lhs.residue.rawValue,
            rhs.residue.rawValue,
            modulus: modulus.value.rawValue
        )
        return Element(__unchecked: Ordinal::Ordinal(reduced))
    }

    @inlinable
    public static func inverse(_ element: Element, modulus: Modulus) -> Element {
        let residue = element.residue.rawValue % modulus.value.rawValue
        if residue == 0 { return Element(__unchecked: .zero) }
        return Element(
            __unchecked: Ordinal::Ordinal(
                modulus.value.rawValue - residue
            )
        )
    }
}

@usableFromInline
func __cyclicAdd(_ lhs: UInt, _ rhs: UInt, modulus: UInt) -> UInt {
    let lhs = lhs % modulus
    let rhs = rhs % modulus
    let remaining = modulus - lhs
    return rhs >= remaining ? rhs - remaining : lhs + rhs
}

@usableFromInline
func __cyclicSubtract(_ lhs: UInt, _ rhs: UInt, modulus: UInt) -> UInt {
    let lhs = lhs % modulus
    let rhs = rhs % modulus
    return lhs >= rhs ? lhs - rhs : modulus - (rhs - lhs)
}
