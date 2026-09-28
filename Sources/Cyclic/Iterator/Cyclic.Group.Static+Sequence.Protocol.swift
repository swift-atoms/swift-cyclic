#if Iterator
public import Cardinal
public import Iterator

public typealias CyclicGroupIterator<let modulus: Int> =
    Cyclic.Group.Static<modulus>.Iterator

public typealias CyclicMaterializingIterator<let modulus: Int> =
    Iterator.Materializing<CyclicGroupIterator<modulus>>

extension Cyclic.Group.Static: Iterable {

    @_implements(Iterable,Iterator)
    public typealias IterableIterator = CyclicMaterializingIterator<modulus>

    @inlinable
    @_lifetime(borrow self)
    @_implements(Iterable,makeIterator())
    public borrowing func iterableMakeIterator()
        -> CyclicMaterializingIterator<modulus>
    {
        CyclicMaterializingIterator<modulus>(CyclicGroupIterator<modulus>())
    }

    @inlinable
    public func makeIterator() -> Iterator {
        Iterator()
    }
}

extension Cyclic.Group.Static: Swift.Sequence {

    @inlinable
    public var underestimatedCount: Int { Self.modulus }
}

extension Cyclic.Group.Static {

    @inlinable
    public static var count: Cardinal {

        Cardinal(UInt(modulus))
    }
}
#endif
