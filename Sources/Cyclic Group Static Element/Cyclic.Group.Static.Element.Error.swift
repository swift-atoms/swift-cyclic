public import Cyclic
public import Cyclic_Group_Static

extension Cyclic::Cyclic.Group.Static.Element {

    public enum Error: Swift.Error, Hashable, Sendable {

        case invalidModulus

        case outOfBounds(Int)
    }
}
