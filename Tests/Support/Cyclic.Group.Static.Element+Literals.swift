public import Cyclic
public import Cyclic_Group_Static
public import Cyclic_Group_Static_Element
import Ordinal

extension Cyclic::Cyclic.Group.Static.Element: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: Int) {
        do throws(Self.Error) {
            self = try Self(Ordinal::Ordinal(UInt(value)))
        } catch {
            preconditionFailure("Literal \(value) invalid for Cyclic.Group.Static<\(modulus)>.Element")
        }
    }
}
