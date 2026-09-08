import Cardinal
import Ordinal
import Testing

@testable import Cyclic

extension Cyclic.Group {
    @Suite
    struct `Dynamic cyclic groups normalize residues under a positive modulus` {
        @Suite struct `Cyclic group arithmetic wraps residues and preserves group laws` {}
        @Suite struct `Cyclic group construction rejects a zero modulus` {}
    }
}

extension Cyclic.Group.`Dynamic cyclic groups normalize residues under a positive modulus`.`Cyclic group arithmetic wraps residues and preserves group laws` {

    @Test
    func `A positive modulus preserves its requested value`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        #expect(modulus.value == Cardinal(5))
    }

    @Test
    func `Cyclic element construction reduces positions modulo the group order`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))

        let e0 = Cyclic.Group.Element(Ordinal(0), modulus: modulus)
        #expect(e0.residue == Ordinal(0))

        let e3 = Cyclic.Group.Element(Ordinal(3), modulus: modulus)
        #expect(e3.residue == Ordinal(3))

        let e7 = Cyclic.Group.Element(Ordinal(7), modulus: modulus)
        #expect(e7.residue == Ordinal(2))
    }

    @Test
    func `Element and Modulus are intrinsically hashable`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let elements: Set = [
            Cyclic.Group.Element(Ordinal(2), modulus: modulus),
            Cyclic.Group.Element(Ordinal(7), modulus: modulus),
        ]
        let moduli: Set = [modulus, try Cyclic.Group.Modulus(Cardinal(5))]

        #expect(elements.count == 1)
        #expect(moduli.count == 1)
    }

    @Test
    func `Cyclic successor advances an interior residue by one`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let element = Cyclic.Group.Element(__unchecked: Ordinal(2))
        let next = Cyclic.Group.successor(element, modulus: modulus)
        #expect(next.residue == Ordinal(3))
    }

    @Test
    func `Cyclic successor wraps the final residue to zero`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let element = Cyclic.Group.Element(__unchecked: Ordinal(4))
        let next = Cyclic.Group.successor(element, modulus: modulus)
        #expect(next.residue == Ordinal(0))
    }

    @Test
    func `Cyclic predecessor retreats an interior residue by one`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let element = Cyclic.Group.Element(__unchecked: Ordinal(3))
        let prev = Cyclic.Group.predecessor(element, modulus: modulus)
        #expect(prev.residue == Ordinal(2))
    }

    @Test
    func `Cyclic predecessor wraps zero to the final residue`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let element = Cyclic.Group.Element.zero
        let prev = Cyclic.Group.predecessor(element, modulus: modulus)
        #expect(prev.residue == Ordinal(4))
    }

    @Test
    func `Cyclic addition preserves a sum below the modulus`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(10))
        let a = Cyclic.Group.Element(__unchecked: Ordinal(3))
        let b = Cyclic.Group.Element(__unchecked: Ordinal(4))
        let sum = Cyclic.Group.add(a, b, modulus: modulus)
        #expect(sum.residue == Ordinal(7))
    }

    @Test
    func `Cyclic addition reduces a sum crossing the modulus`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let a = Cyclic.Group.Element(__unchecked: Ordinal(4))
        let b = Cyclic.Group.Element(__unchecked: Ordinal(3))
        let sum = Cyclic.Group.add(a, b, modulus: modulus)
        #expect(sum.residue == Ordinal(2))
    }

    @Test
    func `Cyclic subtraction preserves a nonnegative residue difference`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(10))
        let a = Cyclic.Group.Element(__unchecked: Ordinal(7))
        let b = Cyclic.Group.Element(__unchecked: Ordinal(3))
        let diff = Cyclic.Group.subtract(a, b, modulus: modulus)
        #expect(diff.residue == Ordinal(4))
    }

    @Test
    func `Cyclic subtraction wraps a negative residue difference`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let a = Cyclic.Group.Element(__unchecked: Ordinal(1))
        let b = Cyclic.Group.Element(__unchecked: Ordinal(3))
        let diff = Cyclic.Group.subtract(a, b, modulus: modulus)
        #expect(diff.residue == Ordinal(3))
    }

    @Test
    func `Inverse property element plus inverse equals zero`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(7))
        let element = Cyclic.Group.Element(__unchecked: Ordinal(4))
        let inv = Cyclic.Group.inverse(element, modulus: modulus)
        let sum = Cyclic.Group.add(element, inv, modulus: modulus)
        #expect(sum.residue == Ordinal(0))
    }

    @Test
    func `Inverse of zero is zero`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let inv = Cyclic.Group.inverse(.zero, modulus: modulus)
        #expect(inv.residue == Ordinal(0))
    }

    @Test
    func `Cyclic index advancement wraps after reaching capacity`() throws(Cyclic.Group.Modulus.Error) {
        let capacity = try Cyclic.Group.Modulus(Cardinal(4))
        var tail = Cyclic.Group.Element.zero

        tail = Cyclic.Group.successor(tail, modulus: capacity)
        #expect(tail.residue == Ordinal(1))

        tail = Cyclic.Group.successor(tail, modulus: capacity)
        #expect(tail.residue == Ordinal(2))

        tail = Cyclic.Group.successor(tail, modulus: capacity)
        #expect(tail.residue == Ordinal(3))

        tail = Cyclic.Group.successor(tail, modulus: capacity)
        #expect(tail.residue == Ordinal(0))
    }
}

extension Cyclic.Group.`Dynamic cyclic groups normalize residues under a positive modulus`.`Cyclic group construction rejects a zero modulus` {

    @Test
    func `Zero modulus throws`() {
        #expect(throws: Cyclic.Group.Modulus.Error.zeroModulus) {
            _ = try Cyclic.Group.Modulus(Cardinal::Cardinal(UInt.zero))
        }
    }
}
