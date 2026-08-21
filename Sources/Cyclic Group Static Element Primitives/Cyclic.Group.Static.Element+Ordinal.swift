public import Cyclic_Group_Static_Primitives
public import Cyclic_Namespace_Primitives
public import Ordinal_Primitives

extension Ordinal {

    @inlinable
    public init<let N: Int>(_ element: Cyclic.Group.Static<N>.Element) {
        self = element.position
    }
}
