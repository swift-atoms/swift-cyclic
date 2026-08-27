public import Cardinal

extension Cyclic.Group {

    public struct Modulus: Hashable, Sendable {

        public let value: Cardinal

        @inlinable
        public init(_ value: Cardinal) throws(Self.Error) {
            guard value.rawValue > 0 else { throw .zeroModulus }
            self.value = value
        }

        @inlinable
        public init(__unchecked value: Cardinal) {
            self.value = value
        }

    }
}

extension Cyclic.Group.Modulus {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value.rawValue == rhs.value.rawValue
    }

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value.rawValue)
    }
}

extension Cyclic.Group.Modulus: CustomStringConvertible {

    public var description: String {
        "Cyclic.Group.Modulus(\(value.rawValue))"
    }
}
