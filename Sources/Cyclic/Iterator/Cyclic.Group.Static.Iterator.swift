#if Iterator
public import Cardinal
public import Iterator
internal import Ordinal

public typealias CyclicScalarIteratorProtocol = Iterator.`Protocol`

extension Cyclic.Group.Static {

    public struct Iterator: CyclicScalarIteratorProtocol, IteratorProtocol, Sendable {
        @usableFromInline
        var current: Ordinal

        @usableFromInline
        let bound: Cardinal

        @inlinable
        package init() {
            self.current = Ordinal(0)

            self.bound = Cardinal(UInt(modulus))
        }

        @inlinable
        public mutating func next() -> Cyclic.Group.Static<modulus>.Element? {
            guard current.rawValue < bound.rawValue else { return nil }

            let element = Cyclic.Group.Static<modulus>.Element(__unchecked: current)
            current = Ordinal(current.rawValue + 1)
            return element
        }
    }
}
#endif
