internal import Cardinal
public import Cyclic_Namespace
public import Index
internal import Ordinal

extension Cyclic.Group {

    public struct Element: Hashable, Comparable, Sendable {

        public let residue: Ordinal

        @inlinable
        public init(_ residue: Ordinal, modulus: Modulus) {
            self.residue = residue % modulus.value
        }

        @inlinable
        public init(__unchecked residue: Ordinal) {
            self.residue = residue
        }

        @inlinable
        public init<Tag: ~Copyable & ~Escapable>(__unchecked index: Index<Tag>) {
            self.residue = index.ordinal
        }

    }
}

extension Cyclic.Group.Element {

    @inlinable
    public static var zero: Self { Self(__unchecked: .zero) }

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
        hasher.combine(residue)
    }
}

extension Cyclic.Group.Element: CustomStringConvertible {

    public var description: String {
        "Cyclic.Group.Element(\(residue))"
    }
}
