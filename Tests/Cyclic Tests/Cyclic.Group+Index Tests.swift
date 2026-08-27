import Testing
import Cardinal
import Index
import Ordinal
@_spi(Internal) import Tagged

@testable import Cyclic

private enum Slot {}

extension Cyclic.Group {
    @Suite
    struct `Index Test` {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

extension Cyclic.Group.`Index Test`.Unit {

    @Test
    func `Element from typed Index`() {
        let index: Index<Slot> = .init(_unchecked: Ordinal(3))
        let element = Cyclic.Group.Element(__unchecked: index)
        #expect(element.residue == Ordinal(3))
    }

    @Test
    func `advanced by positive offset within modulus`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(10))
        let start = Cyclic.Group.Element(__unchecked: Ordinal(2))
        let advanced = Cyclic.Group.advanced(start, by: 3, modulus: modulus)
        #expect(advanced.residue == Ordinal(5))
    }

    @Test
    func `advanced by positive offset wraps at modulus`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let start = Cyclic.Group.Element(__unchecked: Ordinal(4))
        let advanced = Cyclic.Group.advanced(start, by: 3, modulus: modulus)
        #expect(advanced.residue == Ordinal(2))
    }

    @Test
    func `advanced by negative offset within modulus`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(10))
        let start = Cyclic.Group.Element(__unchecked: Ordinal(7))
        let advanced = Cyclic.Group.advanced(start, by: -3, modulus: modulus)
        #expect(advanced.residue == Ordinal(4))
    }

    @Test
    func `advanced by negative offset wraps below zero`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let start = Cyclic.Group.Element(__unchecked: Ordinal(1))
        let advanced = Cyclic.Group.advanced(start, by: -3, modulus: modulus)
        #expect(advanced.residue == Ordinal(3))
    }
}
