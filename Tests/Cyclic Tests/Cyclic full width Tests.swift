import Cardinal
import Cyclic
import Ordinal
import Testing

@Suite struct `Cyclic operations preserve full width residues` {
    @Test(arguments: [UInt(1), 2, 3, 5, 97, UInt(Int.max) + 1, UInt.max])
    func `group operations agree with exact integer arithmetic`(capacity: UInt) throws {
        let modulus = try Cyclic.Group.Modulus(Cardinal(capacity))
        let values: [UInt] = [0, 1, 2, capacity - 1, UInt(Int.max), UInt.max - 1, UInt.max]
        for lhs in values {
            let a = Cyclic.Group.Element(__unchecked: Ordinal(lhs))
            #expect(Cyclic.Group.successor(a, modulus: modulus).residue.rawValue == reduced(Int128(lhs) + 1, capacity))
            #expect(Cyclic.Group.predecessor(a, modulus: modulus).residue.rawValue == reduced(Int128(lhs) - 1, capacity))
            #expect(Cyclic.Group.inverse(a, modulus: modulus).residue.rawValue == reduced(-Int128(lhs), capacity))
            for rhs in values {
                let b = Cyclic.Group.Element(__unchecked: Ordinal(rhs))
                #expect(Cyclic.Group.add(a, b, modulus: modulus).residue.rawValue == reduced(Int128(lhs) + Int128(rhs), capacity))
                #expect(Cyclic.Group.subtract(a, b, modulus: modulus).residue.rawValue == reduced(Int128(lhs) - Int128(rhs), capacity))
            }
        }
    }
}

private func reduced(_ value: Int128, _ capacity: UInt) -> UInt {
    let modulus = Int128(capacity)
    let remainder = value % modulus
    return UInt(remainder < 0 ? remainder + modulus : remainder)
}
