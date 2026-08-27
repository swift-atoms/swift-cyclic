public import Ordinal

extension Ordinal {

    @inlinable
    public init<let N: Int>(_ element: Cyclic.Group.Static<N>.Element) {
        self = element.position
    }
}
