import Cardinal
import Cyclic
import Hash
import Ordinal
import Testing

@Suite
struct `Cyclic Hash Tests` {

    @Test
    func `Static Element supplies Hash's domain-typed value`() {
        let value = Cyclic::Cyclic.Group.Static<5>.Element(
            __unchecked: Ordinal::Ordinal(2)
        )

        #expect(hash(value) == hash(value))
    }

    @Test
    func `Dynamic Element supplies Hash's domain-typed value`() {
        let value = Cyclic::Cyclic.Group.Element(
            __unchecked: Ordinal::Ordinal(2)
        )

        #expect(hash(value) == hash(value))
    }

    @Test
    func `Modulus supplies Hash's domain-typed value`() {
        let value = Cyclic::Cyclic.Group.Modulus(
            __unchecked: Cardinal::Cardinal(5)
        )

        #expect(hash(value) == hash(value))
    }
}

private func hash<T: Hash::Hash.`Protocol`>(
    _ value: borrowing T
) -> Hash::Hash.Value {
    value.hashValue
}
