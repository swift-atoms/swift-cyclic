public import Cardinal
public import Ordinal

extension Cyclic.Group {

    @inlinable
    public static func successor(_ element: Element, modulus: Modulus) -> Element {
        Element(
            __unchecked: Ordinal(
                Cyclic.modularSum(
                    element.residue.rawValue,
                    1,
                    modulus: modulus.value.rawValue
                )
            )
        )
    }

    @inlinable
    public static func predecessor(_ element: Element, modulus: Modulus) -> Element {

        Element(
            __unchecked: Ordinal(
                Cyclic.modularDifference(
                    element.residue.rawValue,
                    1,
                    modulus: modulus.value.rawValue
                )
            )
        )
    }

    @inlinable
    public static func add(_ lhs: Element, _ rhs: Element, modulus: Modulus) -> Element {
        Element(
            __unchecked: Ordinal(
                Cyclic.modularSum(
                    lhs.residue.rawValue,
                    rhs.residue.rawValue,
                    modulus: modulus.value.rawValue
                )
            )
        )
    }

    @inlinable
    public static func subtract(_ lhs: Element, _ rhs: Element, modulus: Modulus) -> Element {

        Element(
            __unchecked: Ordinal(
                Cyclic.modularDifference(
                    lhs.residue.rawValue,
                    rhs.residue.rawValue,
                    modulus: modulus.value.rawValue
                )
            )
        )
    }

    @inlinable
    public static func inverse(_ element: Element, modulus: Modulus) -> Element {
        Element(
            __unchecked: Ordinal(
                Cyclic.modularDifference(
                    0,
                    element.residue.rawValue,
                    modulus: modulus.value.rawValue
                )
            )
        )
    }

    @inlinable
    public static func advanced(
        _ element: Element,
        by offset: Int,
        modulus: Modulus
    ) -> Element {
        let position = offset >= 0
            ? Cyclic.modularSum(
                element.residue.rawValue,
                offset.magnitude,
                modulus: modulus.value.rawValue
            )
            : Cyclic.modularDifference(
                element.residue.rawValue,
                offset.magnitude,
                modulus: modulus.value.rawValue
            )
        return Element(__unchecked: Ordinal(position))
    }
}
