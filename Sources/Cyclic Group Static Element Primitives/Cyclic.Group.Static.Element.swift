public import Cardinal_Primitives
public import Cyclic_Group_Static_Primitives
public import Cyclic_Namespace_Primitives
public import Ordinal_Primitives

extension Cyclic.Group.Static {

    public struct Element: Hashable, Comparable, Sendable {

        public let position: Ordinal

        @inlinable
        public init(_ position: Ordinal) throws(Self.Error) {
            guard modulus > 0 else { throw .invalidModulus }
            guard position < Self.order else {
                throw .outOfBounds(Int(position.rawValue))
            }
            self.position = position
        }

        @inlinable
        public init(__unchecked position: Ordinal) {
            self.position = position
        }

        @inlinable
        public init(wrapping position: Ordinal) {
            precondition(modulus > 0, "Cyclic group modulus must be positive")
            self.position = position % Self.order
        }

    }
}

extension Cyclic.Group.Static.Element {

    @inlinable
    public static var order: Cardinal {
        precondition(
            modulus > 0,
            "Cyclic group order must be positive; Cyclic.Group.Static<\(modulus)> has no elements"
        )

        return try! Cardinal(modulus)
    }
}

extension Cyclic.Group.Static.Element {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.position == rhs.position
    }
}

extension Cyclic.Group.Static.Element {

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

extension Cyclic.Group.Static.Element {

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }
}

extension Cyclic.Group.Static.Element: CustomStringConvertible {

    public var description: String {
        "Cyclic.Group.Static<\(modulus)>.Element(\(position))"
    }
}
