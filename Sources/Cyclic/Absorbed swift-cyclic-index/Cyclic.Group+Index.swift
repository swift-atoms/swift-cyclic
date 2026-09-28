#if Index
public import Cardinal
public import Difference
public import Index
public import Ordinal
public import Tagged

extension Cyclic.Group.Element {

    @inlinable
    public init<Tag: ~Copyable & ~Escapable>(
        __unchecked index: Index::Index<Tag>
    ) {
        self.init(__unchecked: index.underlying)
    }
}

extension Cyclic.Group.Modulus {

    @inlinable
    public init<Tag: ~Copyable & ~Escapable>(
        _ count: Index::Index<Tag>.Count
    ) throws(Self.Error) {
        try self.init(count.underlying)
    }

    @inlinable
    public init<Tag: ~Copyable & ~Escapable>(
        __unchecked count: Index::Index<Tag>.Count
    ) {
        self.init(__unchecked: count.underlying)
    }
}

extension Cyclic.Group {

    @inlinable
    public static func advanced<Tag: ~Copyable & ~Escapable>(
        _ element: Element,
        by offset: Index::Index<Tag>.Offset,
        modulus: Modulus
    ) -> Element {
        precondition(modulus.value.rawValue > 0, "Cyclic index capacity must be positive")
        let difference = offset.underlying
        let distance = difference.magnitude.value.rawValue % modulus.value.rawValue
        let displacement = Element(
            __unchecked: Ordinal::Ordinal(distance)
        )

        return difference.polarity == .negative
            ? subtract(element, displacement, modulus: modulus)
            : add(element, displacement, modulus: modulus)
    }
}
#endif
