public import Cyclic

extension Cyclic::Cyclic.Group.Modulus {

    public enum Error: Swift.Error, Hashable, Sendable {

        case zeroModulus
    }
}
