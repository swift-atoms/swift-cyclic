import Cardinal
import Ordinal

extension Cyclic::Cyclic.Group.Element: Swift.CustomStringConvertible {

    public var description: String {
        "Cyclic.Group.Element(\(residue))"
    }
}
