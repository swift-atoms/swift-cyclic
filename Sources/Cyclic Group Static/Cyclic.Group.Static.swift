public import Cyclic_Namespace

extension Cyclic.Group {

    public struct Static<let modulus: Int>: Sendable {

        @inlinable
        public init() {}
    }
}
