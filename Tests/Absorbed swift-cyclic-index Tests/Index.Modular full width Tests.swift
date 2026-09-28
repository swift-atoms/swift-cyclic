#if Index
import Cardinal
import Cyclic
import Difference
import Index
import Ordinal
import Tagged
import Testing

private struct Domain: ~Copyable, ~Escapable {}

@Suite struct `Modular indices preserve full width offsets` {
    @Test(arguments: [UInt(1), 2, 3, 5, 97, UInt(Int.max) + 1, UInt.max])
    func `signed offsets agree with an exact integer oracle`(capacity: UInt) {
        let count = Index<Domain>.Count(Cardinal(capacity))
        let magnitudes: [UInt] = [0, 1, 2, UInt(Int.max), UInt(Int.max) + 1, UInt.max - 1, UInt.max]
        for position in [0, 1, 2, capacity - 1, UInt.max] {
            let index = Index<Domain>(Ordinal(position))
            for magnitude in magnitudes {
                for negative in [false, true] {
                    let difference = Difference(
                        polarity: negative ? .negative : .positive,
                        magnitude: .init(Cardinal(magnitude))
                    )
                    let offset = Index<Domain>.Offset(difference)
                    let result = Index<Domain>.Modular.advanced(index, by: offset, capacity: count)
                    let signed = negative ? -Int128(magnitude) : Int128(magnitude)

                    #expect(result.underlying.rawValue == reduced(Int128(position) + signed, capacity))
                    #expect(result.underlying.rawValue < capacity)
                }
            }
        }
    }

    @Test
    func `count conversion cannot reverse a positive offset`() {
        let count = Index<Domain>.Count(Cardinal(UInt.max))
        let result = Index<Domain>.Modular.advanced(
            Index<Domain>(Ordinal(2)),
            by: Index<Domain>.Offset(count),
            capacity: Index<Domain>.Count(Cardinal(5))
        )
        #expect(result.underlying == Ordinal(2))
    }

    @Test
    func `minimum signed offset retains its magnitude`() {
        let result = Index<Domain>.Modular.advanced(
            Index<Domain>(Ordinal(UInt.max)),
            by: Index<Domain>.Offset(Int.min),
            capacity: Index<Domain>.Count(Cardinal(UInt.max))
        )
        #expect(result.underlying.rawValue == reduced(Int128(UInt.max) + Int128(Int.min), UInt.max))
    }

    @Test
    func `physical indexing avoids overflow before reduction`() {
        let result = Index<Domain>.Modular.physical(
            forLogical: Index<Domain>(Ordinal(UInt.max - 1)),
            head: Index<Domain>(Ordinal(UInt.max - 1)),
            capacity: Index<Domain>.Count(Cardinal(UInt.max))
        )
        #expect(result.underlying.rawValue == UInt.max - 2)
    }

    @Test
    func `checked typed modulus rejects zero`() {
        #expect(throws: Cyclic.Group.Modulus.Error.zeroModulus) {
            try Cyclic.Group.Modulus(Index<Domain>.Count(Cardinal(UInt.zero)))
        }
    }

    @Test
    func `successor requires positive capacity`() async {
        await #expect(processExitsWith: .failure) {
            _ = Index<Domain>.Modular.successor(of: .zero, capacity: .zero)
        }
    }

    @Test
    func `predecessor requires positive capacity`() async {
        await #expect(processExitsWith: .failure) {
            _ = Index<Domain>.Modular.predecessor(of: .zero, capacity: .zero)
        }
    }

    @Test
    func `advancement requires positive capacity`() async {
        await #expect(processExitsWith: .failure) {
            _ = Index<Domain>.Modular.advanced(.zero, by: .zero, capacity: .zero)
        }
    }

    @Test
    func `physical indexing requires positive capacity`() async {
        await #expect(processExitsWith: .failure) {
            _ = Index<Domain>.Modular.physical(forLogical: .zero, head: .zero, capacity: .zero)
        }
    }
}

private func reduced(_ value: Int128, _ capacity: UInt) -> UInt {
    let modulus = Int128(capacity)
    let remainder = value % modulus
    return UInt(remainder < 0 ? remainder + modulus : remainder)
}
#endif
