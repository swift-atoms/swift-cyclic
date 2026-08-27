public import Cardinal
public import Index
public import Ordinal
@_spi(Internal) public import Tagged

extension Cyclic.Group {

    public struct Element: Hashable, Comparable, Sendable {

        public let residue: Ordinal

        @inlinable
        public init(_ residue: Ordinal, modulus: Modulus) {
            self.residue = Ordinal(residue.rawValue % modulus.value.rawValue)
        }

        @inlinable
        public init(__unchecked residue: Ordinal) {
            self.residue = residue
        }

        public init<Tag: ~Copyable & ~Escapable>(__unchecked index: Index<Tag>) {
            self.residue = index.underlying
        }

    }
}

extension Cyclic.Group.Element {

    @inlinable
    public static var zero: Self { Self(__unchecked: Ordinal(0)) }

    @inlinable
    public static var one: Self { Self(__unchecked: Ordinal(1)) }
}

extension Cyclic.Group.Element {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.residue == rhs.residue
    }
}

extension Cyclic.Group.Element {

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.residue < rhs.residue
    }
}

extension Cyclic.Group.Element {

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(residue.rawValue)
    }
}

extension Cyclic.Group.Element: CustomStringConvertible {

    public var description: String {
        "Cyclic.Group.Element(\(residue.rawValue))"
    }
}
