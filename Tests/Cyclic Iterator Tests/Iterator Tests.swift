#if Iterator
import Cyclic
import Testing

@Suite
struct `Cyclic Iterator Tests` {
    @Suite struct Unit {}
}

extension `Cyclic Iterator Tests`.Unit {
    @Test
    func `count equals the modulus`() {
        let count: Cardinal = Cyclic.Group.Static<5>.count
        #expect(count == Cardinal(UInt(5)))
    }

    @Test
    func `iterating runs exactly modulus times`() {
        var iterations = 0
        for _ in Cyclic.Group.Static<5>() {
            iterations += 1
        }
        #expect(iterations == 5)
    }

    @Test
    func `element positions are zero through four in order`() {
        let elements: [Cyclic.Group.Static<5>.Element] = Array(Cyclic.Group.Static<5>())
        let expected: [Cyclic.Group.Static<5>.Element] = (0..<5).map {
            Cyclic.Group.Static<5>.Element(wrapping: Ordinal(UInt($0)))
        }
        #expect(elements == expected)
    }
}
#endif
