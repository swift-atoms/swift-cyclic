public import Cyclic_Group_Static_Primitives
public import Cyclic_Namespace_Primitives

extension Cyclic.Group.Static.Element {

    public enum Error: Swift.Error, Hashable, Sendable {

        case invalidModulus

        case outOfBounds(Int)
    }
}
