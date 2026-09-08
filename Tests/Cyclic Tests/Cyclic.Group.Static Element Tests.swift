import Cardinal
import Cyclic_Test_Support
import Ordinal
import Testing

@testable import Cyclic

extension Cyclic.Group {
    @Suite
    struct `Static cyclic elements preserve their order through construction and arithmetic` {
        @Suite struct `Static cyclic arithmetic wraps positions and preserves group identities` {}
        @Suite struct `Static cyclic boundaries reject invalid orders and positions` {}
    }
}

extension Cyclic.Group.`Static cyclic elements preserve their order through construction and arithmetic`.`Static cyclic arithmetic wraps positions and preserves group identities` {

    @Test
    func `Checked static cyclic construction preserves positions within the order`() throws(Cyclic.Group.Static<5>.Element.Error) {
        let g0 = try Cyclic.Group.Static<5>.Element(Ordinal(0))
        #expect(g0.position == 0)

        let g4 = try Cyclic.Group.Static<5>.Element(Ordinal(4))
        #expect(g4.position == 4)
    }

    @Test
    func `Zero is identity`() {
        let zero = Cyclic.Group.Static<5>.Element.zero
        #expect(zero.position == 0)
    }

    @Test
    func `One is generator`() {
        let one = Cyclic.Group.Static<5>.Element.one
        #expect(one.position == 1)
    }

    @Test
    func `One equals zero for modulus 1`() {
        let one = Cyclic.Group.Static<1>.Element.one
        let zero = Cyclic.Group.Static<1>.Element.zero
        #expect(one == zero)
        #expect(one.position == 0)
    }

    @Test
    func `Static cyclic addition preserves a sum below the order`() {
        let a: Cyclic.Group.Static<10>.Element = 3
        let b: Cyclic.Group.Static<10>.Element = 4
        let sum = a + b
        #expect(sum.position == 7)
    }

    @Test
    func `Static cyclic addition reduces a sum crossing the order`() {
        let a: Cyclic.Group.Static<5>.Element = 4
        let b: Cyclic.Group.Static<5>.Element = 3
        let sum = a + b
        #expect(sum.position == 2)
    }

    @Test
    func `Identity property a plus zero equals a`() {
        let a: Cyclic.Group.Static<7>.Element = 4
        let result = a + .zero
        #expect(result == a)
    }

    @Test
    func `Static cyclic subtraction preserves a nonnegative position difference`() {
        let a: Cyclic.Group.Static<10>.Element = 7
        let b: Cyclic.Group.Static<10>.Element = 3
        let diff = a - b
        #expect(diff.position == 4)
    }

    @Test
    func `Static cyclic subtraction wraps a negative position difference`() {
        let a: Cyclic.Group.Static<5>.Element = 1
        let b: Cyclic.Group.Static<5>.Element = 3
        let diff = a - b
        #expect(diff.position == 3)
    }

    @Test
    func `Inverse property a plus inverse equals zero`() {
        let a: Cyclic.Group.Static<7>.Element = 4
        let inv = a.inverse
        let result = a + inv
        #expect(result == .zero)
    }

    @Test
    func `Inverse of zero is zero`() {
        let zero = Cyclic.Group.Static<5>.Element.zero
        #expect(zero.inverse == .zero)
    }

    @Test
    func `Compound cyclic addition updates and wraps the stored position`() {
        var g: Cyclic.Group.Static<5>.Element = 3
        g += .one
        #expect(g.position == 4)
        g += .one
        #expect(g.position == 0)
    }

    @Test
    func `Compound cyclic subtraction updates and wraps the stored position`() {
        var g: Cyclic.Group.Static<5>.Element = 1
        g -= .one
        #expect(g.position == 0)
        g -= .one
        #expect(g.position == 4)
    }

    @Test
    func `Cyclic index advancement wraps after reaching capacity`() {
        var tail = Cyclic.Group.Static<4>.Element.zero

        tail += .one
        #expect(tail.position == 1)

        tail += .one
        #expect(tail.position == 2)

        tail += .one
        #expect(tail.position == 3)

        tail += .one
        #expect(tail.position == 0)
    }

    @Test
    func `Static cyclic elements compare according to their positions`() {
        let a: Cyclic.Group.Static<5>.Element = 2
        let b: Cyclic.Group.Static<5>.Element = 4
        #expect(a < b)
        #expect(!(b < a))
        #expect(!(a < a))
    }

    @Test
    func `Static elements are intrinsically hashable`() {
        let a: Cyclic.Group.Static<5>.Element = 2
        let b: Cyclic.Group.Static<5>.Element = 2
        let values: Set = [a, b]

        #expect(values.count == 1)
    }

    @Test
    func `A static cyclic group exposes its declared modulus`() {
        #expect(Cyclic.Group.Static<7>.modulus == 7)
        #expect(Cyclic.Group.Static<1>.modulus == 1)
        #expect(Cyclic.Group.Static<100>.modulus == 100)
    }
}

extension Cyclic.Group.`Static cyclic elements preserve their order through construction and arithmetic`.`Static cyclic boundaries reject invalid orders and positions` {

    @Test
    func `Out of bounds construction throws`() {
        #expect(throws: Cyclic.Group.Static<5>.Element.Error.outOfBounds(5)) {
            _ = try Cyclic.Group.Static<5>.Element(Ordinal(5))
        }
        #expect(throws: Cyclic.Group.Static<5>.Element.Error.outOfBounds(100)) {
            _ = try Cyclic.Group.Static<5>.Element(Ordinal(100))
        }
    }

    @Test
    func `full width invalid positions survive typed error construction`() {
        let position = Ordinal(UInt.max)
        do {
            _ = try Cyclic.Group.Static<5>.Element(position)
            Issue.record("An out of bounds position was accepted")
        } catch {
            #expect(error == .outOfBounds(position))
            #expect(Set([error, .outOfBounds(position)]).count == 1)
        }
    }

    @Test
    func `Invalid modulus throws`() {
        #expect(throws: Cyclic.Group.Static<0>.Element.Error.invalidModulus) {
            _ = try Cyclic.Group.Static<0>.Element(Ordinal(0))
        }
    }

    @Test
    func `Subtracting one from cyclic zero produces the final position`() {
        let a: Cyclic.Group.Static<5>.Element = 0
        let b: Cyclic.Group.Static<5>.Element = 1
        let diff = a - b
        #expect(diff.position == 4)
    }

    @Test
    func `Zero-order wrapping construction traps before modulo`() async {
        await #expect(processExitsWith: .failure) {
            _ = Cyclic.Group.Static<0>.Element(wrapping: Ordinal(3))
        }
    }

    @Test
    func `Zero-order addition traps on the order guard, not modulo by zero`() async {
        await #expect(processExitsWith: .failure) {
            let zero = Cyclic.Group.Static<0>.Element.zero
            _ = zero + zero
        }
    }

    @Test
    func `Zero-order subtraction traps on the order guard, not modulo by zero`() async {
        await #expect(processExitsWith: .failure) {
            let zero = Cyclic.Group.Static<0>.Element.zero
            _ = zero - zero
        }
    }

    @Test
    func `Zero-order order access traps`() async {
        await #expect(processExitsWith: .failure) {
            _ = Cyclic.Group.Static<0>.Element.order
        }
    }

    @Test
    func `Order one arithmetic never touches the guard`() {
        let zero = Cyclic.Group.Static<1>.Element.zero
        #expect((zero + zero).position == 0)
        #expect((zero - zero).position == 0)
        #expect(Cyclic.Group.Static<1>.Element.order == 1)
    }
}
