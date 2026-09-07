public import Cardinal
public import Ordinal

extension Cyclic::Cyclic.Group.Static.Element: Swift.CustomStringConvertible {

    public var description: String {
        "Cyclic.Group.Static<\(modulus)>.Element(\(position))"
    }
}
