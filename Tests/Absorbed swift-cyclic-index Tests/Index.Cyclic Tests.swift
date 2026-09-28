#if Index
import Cyclic
import Index
import Ordinal
import Tagged
import Testing

@testable import Cyclic

private enum Slot {}
private enum OtherSlot {}

@Suite
struct `Index Cyclic Tests` {
    @Suite struct `Construction respects the modulus` {}
    @Suite struct `Arithmetic retains the domain` {}
    @Suite struct `Value semantics retain the domain` {}
}

extension `Index Cyclic Tests`.`Construction respects the modulus` {

    @Test
    func `typed ordinal constructs a cyclic index`() throws {
        let index = try Index<Slot>.Cyclic<5>(Ordinal(3))
        #expect(index.underlying.position == Ordinal(3))
    }

    @Test
    func `maximum valid ordinal constructs a cyclic index`() throws {
        let index = try Index<Slot>.Cyclic<5>(Ordinal(4))
        #expect(index.underlying.position == Ordinal(4))
    }

    @Test
    func `wrapping construction preserves the typed boundary`() {
        let index = Index<Slot>.Cyclic<5>(wrapping: Ordinal(8))
        #expect(index.underlying.position == Ordinal(3))
    }

    @Test
    func `ordinal at modulus throws`() {
        #expect(throws: Cyclic.Group.Static<5>.Element.Error.outOfBounds(5)) {
            _ = try Index<Slot>.Cyclic<5>(Ordinal(5))
        }
    }

    @Test
    func `ordinal beyond modulus throws`() {
        #expect(throws: Cyclic.Group.Static<5>.Element.Error.outOfBounds(100)) {
            _ = try Index<Slot>.Cyclic<5>(Ordinal(100))
        }
    }
}

extension `Index Cyclic Tests`.`Arithmetic retains the domain` {

    @Test
    func `tagged addition wraps`() throws {
        let lhs = try Index<Slot>.Cyclic<5>(Ordinal(4))
        let rhs = try Index<Slot>.Cyclic<5>(Ordinal(3))

        #expect((lhs + rhs).underlying.position == Ordinal(2))
    }

    @Test
    func `tagged subtraction wraps`() throws {
        let lhs = try Index<Slot>.Cyclic<5>(Ordinal(1))
        let rhs = try Index<Slot>.Cyclic<5>(Ordinal(3))

        #expect((lhs - rhs).underlying.position == Ordinal(3))
    }

    @Test
    func `compound operations preserve the index tag`() throws {
        var index = try Index<Slot>.Cyclic<5>(Ordinal(4))
        let two = try Index<Slot>.Cyclic<5>(Ordinal(2))

        index += two
        #expect(index.underlying.position == Ordinal(1))

        index -= two
        #expect(index.underlying.position == Ordinal(4))
    }
}

extension `Index Cyclic Tests`.`Value semantics retain the domain` {

    @Test
    func `cyclic indices have intrinsic value semantics`() throws {
        let one = try Index<Slot>.Cyclic<5>(Ordinal(1))
        let duplicate = try Index<Slot>.Cyclic<5>(Ordinal(1))
        let two = try Index<Slot>.Cyclic<5>(Ordinal(2))

        #expect(one == duplicate)
        #expect(one < two)
        #expect(Set([one, duplicate, two]).count == 2)
    }

    @Test
    func `distinct phantom domains retain typed values independently`() throws {
        let slot = try Index<Slot>.Cyclic<5>(Ordinal(3))
        let other = try Index<OtherSlot>.Cyclic<5>(Ordinal(3))

        #expect(slot.underlying.position == other.underlying.position)
    }
}
#endif
