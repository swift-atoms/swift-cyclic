public import Cardinal
public import Cyclic
public import Cyclic_Group_Static
public import Ordinal

extension Cyclic::Cyclic.Group.Static.Element {

    @inlinable
    public static var zero: Self { Self(__unchecked: .zero) }

    @inlinable
    public static var one: Self {
        Self(__unchecked: modulus > 1 ? Ordinal::Ordinal(1 as UInt) : .zero)
    }
}

extension Cyclic::Cyclic.Group.Static.Element {

    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        let reduced = __cyclicAdd(
            lhs.position.rawValue,
            rhs.position.rawValue,
            modulus: Self.order.rawValue
        )
        return Self(__unchecked: Ordinal::Ordinal(reduced))
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {

        let reduced = __cyclicSubtract(
            lhs.position.rawValue,
            rhs.position.rawValue,
            modulus: Self.order.rawValue
        )
        return Self(__unchecked: Ordinal::Ordinal(reduced))
    }

    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}

extension Cyclic::Cyclic.Group.Static.Element {

    @inlinable
    public var inverse: Self {
        let residue = position.rawValue % Self.order.rawValue
        if residue == 0 { return Self(__unchecked: .zero) }
        return Self(__unchecked: Ordinal::Ordinal(Self.order.rawValue - residue))
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
