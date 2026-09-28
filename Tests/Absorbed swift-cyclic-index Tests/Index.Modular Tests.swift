#if Index
import Difference
import Cardinal
import Cyclic
import Index
import Ordinal
import Tagged
import Testing

@testable import Cyclic

private enum Slot {}

private func index(_ rawValue: UInt) -> Index<Slot> {
    Index<Slot>(Ordinal(rawValue))
}

private func count(_ rawValue: UInt) -> Index<Slot>.Count {
    Index<Slot>.Count(Cardinal(rawValue))
}

private func offset(_ rawValue: Int) -> Index<Slot>.Offset {
    Index<Slot>.Offset(rawValue)
}

@Suite
struct `Index Modular Tests` {
    @Suite struct `Valid modular operations` {}
    @Suite struct `Edge Case` {}
    @Suite struct `Ring buffer integration` {}
}

extension `Index Modular Tests`.`Valid modular operations` {

    @Test
    func `successor without wrap`() {
        let next = Index<Slot>.Modular.successor(of: index(2), capacity: count(5))
        #expect(next.underlying == Ordinal(3))
    }

    @Test
    func `predecessor without wrap`() {
        let previous = Index<Slot>.Modular.predecessor(of: index(3), capacity: count(5))
        #expect(previous.underlying == Ordinal(2))
    }

    @Test
    func `positive and negative typed offsets advance`() {
        let forward = Index<Slot>.Modular.advanced(
            index(2),
            by: offset(3),
            capacity: count(10)
        )
        let backward = Index<Slot>.Modular.advanced(
            index(5),
            by: offset(-2),
            capacity: count(10)
        )

        #expect(forward.underlying == Ordinal(5))
        #expect(backward.underlying == Ordinal(3))
    }

    @Test
    func `logical index maps to physical index`() {
        let physical = Index<Slot>.Modular.physical(
            forLogical: index(3),
            head: index(2),
            capacity: count(10)
        )

        #expect(physical.underlying == Ordinal(5))
    }
}

extension `Index Modular Tests`.`Edge Case` {

    @Test
    func `successor and predecessor wrap`() {
        let next = Index<Slot>.Modular.successor(of: index(4), capacity: count(5))
        let previous = Index<Slot>.Modular.predecessor(of: index(0), capacity: count(5))

        #expect(next.underlying == Ordinal(0))
        #expect(previous.underlying == Ordinal(4))
    }

    @Test
    func `typed offsets wrap in both directions`() {
        let forward = Index<Slot>.Modular.advanced(
            index(3),
            by: offset(4),
            capacity: count(5)
        )
        let backward = Index<Slot>.Modular.advanced(
            index(1),
            by: offset(-3),
            capacity: count(5)
        )

        #expect(forward.underlying == Ordinal(2))
        #expect(backward.underlying == Ordinal(3))
    }
}

extension `Index Modular Tests`.`Ring buffer integration` {

    @Test
    func `ring buffer simulation remains in its typed domain`() {
        let capacity = count(4)
        var head = index(0)
        var tail = index(0)

        tail = Index<Slot>.Modular.successor(of: tail, capacity: capacity)
        tail = Index<Slot>.Modular.successor(of: tail, capacity: capacity)
        tail = Index<Slot>.Modular.successor(of: tail, capacity: capacity)
        head = Index<Slot>.Modular.successor(of: head, capacity: capacity)
        tail = Index<Slot>.Modular.successor(of: tail, capacity: capacity)
        tail = Index<Slot>.Modular.successor(of: tail, capacity: capacity)

        #expect(head.underlying == Ordinal(1))
        #expect(tail.underlying == Ordinal(1))
    }
}
#endif
