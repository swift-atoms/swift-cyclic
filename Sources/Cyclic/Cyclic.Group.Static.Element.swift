public import Cardinal
public import Ordinal

extension Cyclic::Cyclic.Group.Static {

    public struct Element: Hashable, Comparable, Sendable {

        public let position: Ordinal::Ordinal

        @inlinable
        public init(_ position: Ordinal::Ordinal) throws(Self.Error) {
            guard modulus > 0 else { throw .invalidModulus }
            guard position.rawValue < Self.order.rawValue else {
                throw .outOfBounds(position)
            }
            self.position = position
        }

        @inlinable
        public init(__unchecked position: Ordinal::Ordinal) {
            self.position = position
        }

        @inlinable
        public init(wrapping position: Ordinal::Ordinal) {
            precondition(modulus > 0, "Cyclic group modulus must be positive")
            self.position = Ordinal::Ordinal(position.rawValue % Self.order.rawValue)
        }

    }
}

extension Cyclic::Cyclic.Group.Static.Element {

    @inlinable
    public static var order: Cardinal::Cardinal {
        precondition(
            modulus > 0,
            "Cyclic group order must be positive; Cyclic.Group.Static<\(modulus)> has no elements"
        )

        return Cardinal::Cardinal(UInt(modulus))
    }
}

extension Cyclic::Cyclic.Group.Static.Element {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.position == rhs.position
    }
}

extension Cyclic::Cyclic.Group.Static.Element {

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.position < rhs.position
    }

    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs.position <= rhs.position
    }

    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.position > rhs.position
    }

    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs.position >= rhs.position
    }
}

extension Cyclic::Cyclic.Group.Static.Element {

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(position.rawValue)
    }
}

extension Cyclic::Cyclic.Group.Static.Element: Swift::CustomStringConvertible {

    public var description: String {
        "Cyclic.Group.Static<\(modulus)>.Element(\(position))"
    }
}

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
