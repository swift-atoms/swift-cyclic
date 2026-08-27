public import Cardinal
public import Ordinal

extension Cyclic.Group.Static.Element {

    @inlinable
    public static var zero: Self { Self(__unchecked: .zero) }

    @inlinable
    public static var one: Self {
        Self(__unchecked: modulus > 1 ? Ordinal(1) : .zero)
    }
}

extension Cyclic.Group.Static.Element {

    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(
            __unchecked: Ordinal(
                Cyclic.modularSum(
                    lhs.position.rawValue,
                    rhs.position.rawValue,
                    modulus: Self.order.rawValue
                )
            )
        )
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {

        Self(
            __unchecked: Ordinal(
                Cyclic.modularDifference(
                    lhs.position.rawValue,
                    rhs.position.rawValue,
                    modulus: Self.order.rawValue
                )
            )
        )
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

extension Cyclic.Group.Static.Element {

    @inlinable
    public var inverse: Self {
        Self(
            __unchecked: Ordinal(
                Cyclic.modularDifference(0, position.rawValue, modulus: Self.order.rawValue)
            )
        )
    }
}
