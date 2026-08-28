public import Cardinal
public import Cyclic

extension Cyclic::Cyclic.Group {

    public struct Modulus: Hashable, Sendable {

        public let value: Cardinal::Cardinal

        @inlinable
        public init(_ value: Cardinal::Cardinal) throws(Self.Error) {
            guard value.rawValue > 0 else { throw .zeroModulus }
            self.value = value
        }

        @inlinable
        public init(__unchecked value: Cardinal::Cardinal) {
            self.value = value
        }
    }
}

extension Cyclic::Cyclic.Group.Modulus {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value.rawValue == rhs.value.rawValue
    }
}

extension Cyclic::Cyclic.Group.Modulus {

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value.rawValue)
    }
}

extension Cyclic::Cyclic.Group.Modulus: CustomStringConvertible {

    public var description: String {
        "Cyclic.Group.Modulus(\(value))"
    }
}
