public import Cyclic_Group_Static
public import Cyclic_Namespace
public import Ordinal

extension Ordinal {

    @inlinable
    public init<let N: Int>(_ element: Cyclic.Group.Static<N>.Element) {
        self = element.position
    }
}
