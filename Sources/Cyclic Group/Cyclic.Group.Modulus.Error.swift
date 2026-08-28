public import Cyclic_Namespace

extension Cyclic.Group.Modulus {

    public enum Error: Swift.Error, Hashable, Sendable {

        case zeroModulus
    }
}
