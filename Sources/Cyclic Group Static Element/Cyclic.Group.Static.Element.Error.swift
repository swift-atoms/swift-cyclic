public import Cyclic_Group_Static
public import Cyclic_Namespace

extension Cyclic.Group.Static.Element {

    public enum Error: Swift.Error, Hashable, Sendable {

        case invalidModulus

        case outOfBounds(Int)
    }
}
