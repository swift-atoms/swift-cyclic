public import Cardinal
public import Cyclic
public import Ordinal

extension Cyclic::Cyclic.Group {

    public struct Element: Hashable, Comparable, Sendable {

        public let residue: Ordinal::Ordinal

        @inlinable
        public init(_ residue: Ordinal::Ordinal, modulus: Modulus) {
            self.residue = Ordinal::Ordinal(residue.rawValue % modulus.value.rawValue)
        }

        @inlinable
        public init(__unchecked residue: Ordinal::Ordinal) {
            self.residue = residue
        }

    }
}

extension Cyclic::Cyclic.Group.Element {

    @inlinable
    public static var zero: Self { Self(__unchecked: .zero) }

    @inlinable
    public static var one: Self { Self(__unchecked: Ordinal::Ordinal(1 as UInt)) }
}

extension Cyclic::Cyclic.Group.Element {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.residue == rhs.residue
    }
}

extension Cyclic::Cyclic.Group.Element {

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.residue < rhs.residue
    }
}

extension Cyclic::Cyclic.Group.Element {

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(residue.rawValue)
    }
}

extension Cyclic::Cyclic.Group.Element: CustomStringConvertible {

    public var description: String {
        "Cyclic.Group.Element(\(residue))"
    }
}
