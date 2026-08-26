public import Cardinal
public import Cyclic_Group_Static
public import Cyclic_Namespace
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
        let sum = lhs.position + Cardinal(rhs.position)
        let reduced = sum % Self.order
        return Self(__unchecked: reduced)
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {

        let inverse = Self.order.subtract.saturating(Cardinal(rhs.position))
        let sum = lhs.position + inverse
        let reduced = sum % Self.order
        return Self(__unchecked: reduced)
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
        if position == .zero { return self }

        let inv = Self.order.subtract.saturating(Cardinal(position))
        return Self(__unchecked: Ordinal(inv))
    }
}
