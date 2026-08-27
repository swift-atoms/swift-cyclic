
extension Cyclic.Group.Static.Element {

    public enum Error: Swift.Error, Hashable, Sendable {

        case invalidModulus

        case outOfBounds(Int)
    }
}
