#if Tagged
public import Ordinal
public import Tagged

extension Tagged::Tagged where Tag: ~Copyable & ~Escapable {

    @inlinable
    public init<let N: Int>(_ element: Cyclic::Cyclic.Group.Static<N>.Element)
    where Underlying == Cyclic::Cyclic.Group.Static<N>.Element {
        self.init(_unchecked: element)
    }

    @inlinable
    public init<let N: Int>(
        _ position: Ordinal::Ordinal
    ) throws(Cyclic::Cyclic.Group.Static<N>.Element.Error)
    where Underlying == Cyclic::Cyclic.Group.Static<N>.Element {
        self.init(_unchecked: try Cyclic::Cyclic.Group.Static<N>.Element(position))
    }

    @inlinable
    public init<let N: Int>(wrapping position: Ordinal::Ordinal)
    where Underlying == Cyclic::Cyclic.Group.Static<N>.Element {
        self.init(
            _unchecked: Cyclic::Cyclic.Group.Static<N>.Element(wrapping: position)
        )
    }
}

extension Tagged::Tagged where Tag: ~Copyable & ~Escapable {

    @inlinable
    public static func + <let N: Int>(lhs: Self, rhs: Self) -> Self
    where Underlying == Cyclic::Cyclic.Group.Static<N>.Element {
        Self(_unchecked: lhs.underlying + rhs.underlying)
    }

    @inlinable
    public static func - <let N: Int>(lhs: Self, rhs: Self) -> Self
    where Underlying == Cyclic::Cyclic.Group.Static<N>.Element {
        Self(_unchecked: lhs.underlying - rhs.underlying)
    }

    @inlinable
    public static func += <let N: Int>(lhs: inout Self, rhs: Self)
    where Underlying == Cyclic::Cyclic.Group.Static<N>.Element {
        lhs = lhs + rhs
    }

    @inlinable
    public static func -= <let N: Int>(lhs: inout Self, rhs: Self)
    where Underlying == Cyclic::Cyclic.Group.Static<N>.Element {
        lhs = lhs - rhs
    }
}

extension Tagged::Tagged where Tag: ~Copyable & ~Escapable {

    @inlinable
    public func inverse<let N: Int>() -> Self
    where Underlying == Cyclic::Cyclic.Group.Static<N>.Element {
        Self(_unchecked: underlying.inverse)
    }
}
#endif
