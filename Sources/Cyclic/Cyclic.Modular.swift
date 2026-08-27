extension Cyclic {

    @usableFromInline
    static func modularSum(_ lhs: UInt, _ rhs: UInt, modulus: UInt) -> UInt {
        precondition(modulus > 0, "Cyclic group modulus must be positive")

        let left = lhs % modulus
        let right = rhs % modulus
        let distanceToModulus = modulus - right
        return left >= distanceToModulus ? left - distanceToModulus : left + right
    }

    @usableFromInline
    static func modularDifference(_ lhs: UInt, _ rhs: UInt, modulus: UInt) -> UInt {
        precondition(modulus > 0, "Cyclic group modulus must be positive")

        let left = lhs % modulus
        let right = rhs % modulus
        return left >= right ? left - right : modulus - (right - left)
    }
}
