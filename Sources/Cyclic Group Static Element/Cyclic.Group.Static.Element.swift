public import Cardinal
public import Cyclic
public import Cyclic_Group_Static
public import Ordinal

extension Cyclic::Cyclic.Group.Static {

    public struct Element: Hashable, Comparable, Sendable {

        public let position: Ordinal::Ordinal

        @inlinable
        public init(_ position: Ordinal::Ordinal) throws(Self.Error) {
            guard modulus > 0 else { throw .invalidModulus }
            guard position.rawValue < Self.order.rawValue else {
                throw .outOfBounds(Int(position.rawValue))
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

extension Cyclic::Cyclic.Group.Static.Element: CustomStringConvertible {

    public var description: String {
        "Cyclic.Group.Static<\(modulus)>.Element(\(position))"
    }
}
