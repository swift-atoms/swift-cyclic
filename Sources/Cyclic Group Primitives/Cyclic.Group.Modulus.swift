public import Cardinal_Primitives
public import Cyclic_Namespace_Primitives
public import Index_Primitives

extension Cyclic.Group {

    public struct Modulus: Hashable, Sendable {

        public let value: Cardinal

        @inlinable
        public init(_ value: Cardinal) throws(Self.Error) {
            guard value > .zero else { throw .zeroModulus }
            self.value = value
        }

        @inlinable
        public init(__unchecked value: Cardinal) {
            self.value = value
        }

        @inlinable
        public init<Tag: ~Copyable & ~Escapable>(_ count: Index<Tag>.Count) throws(Self.Error) {
            guard count > .zero else { throw .zeroModulus }
            self.value = count.underlying
        }

        @inlinable
        public init<Tag: ~Copyable & ~Escapable>(__unchecked count: Index<Tag>.Count) {
            self.value = count.underlying
        }
    }
}

extension Cyclic.Group.Modulus: CustomStringConvertible {

    public var description: String {
        "Cyclic.Group.Modulus(\(value))"
    }
}
