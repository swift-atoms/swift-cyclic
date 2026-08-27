public import Cyclic
import Ordinal

extension Cyclic.Group.Static.Element: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: Int) {
        do throws(Self.Error) {
            self = try Self(Ordinal(UInt(value)))
        } catch {
            preconditionFailure("Literal \(value) invalid for Cyclic.Group.Static<\(modulus)>.Element")
        }
    }
}
