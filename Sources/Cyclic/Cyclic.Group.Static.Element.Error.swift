public import Ordinal

extension Cyclic::Cyclic.Group.Static.Element {

    public enum Error: Swift.Error, Hashable, Sendable {

        case invalidModulus

        case outOfBounds(Ordinal::Ordinal)
    }
}
