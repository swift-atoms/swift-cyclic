#if Index
public import Index
public import Ordinal
public import Tagged

extension Tagged::Tagged
where Underlying == Ordinal::Ordinal, Tag: ~Copyable & ~Escapable {

    public enum Modular {}
}

extension Tagged::Tagged.Modular
where Underlying == Ordinal::Ordinal, Tag: ~Copyable & ~Escapable {

    @inlinable
    public static func successor(
        of index: Index::Index<Tag>,
        capacity: Index::Index<Tag>.Count
    ) -> Index::Index<Tag> {
        precondition(capacity.underlying.rawValue > 0, "Cyclic index capacity must be positive")
        let modulus = Cyclic.Group.Modulus(__unchecked: capacity)
        let element = Cyclic.Group.Element(__unchecked: index)
        let result = Cyclic.Group.successor(element, modulus: modulus)
        return Index::Index<Tag>(_unchecked: result.residue)
    }

    @inlinable
    public static func predecessor(
        of index: Index::Index<Tag>,
        capacity: Index::Index<Tag>.Count
    ) -> Index::Index<Tag> {
        precondition(capacity.underlying.rawValue > 0, "Cyclic index capacity must be positive")
        let modulus = Cyclic.Group.Modulus(__unchecked: capacity)
        let element = Cyclic.Group.Element(__unchecked: index)
        let result = Cyclic.Group.predecessor(element, modulus: modulus)
        return Index::Index<Tag>(_unchecked: result.residue)
    }

    @inlinable
    public static func advanced(
        _ index: Index::Index<Tag>,
        by offset: Index::Index<Tag>.Offset,
        capacity: Index::Index<Tag>.Count
    ) -> Index::Index<Tag> {
        precondition(capacity.underlying.rawValue > 0, "Cyclic index capacity must be positive")
        let modulus = Cyclic.Group.Modulus(__unchecked: capacity)
        let element = Cyclic.Group.Element(__unchecked: index)
        let result = Cyclic.Group.advanced(element, by: offset, modulus: modulus)
        return Index::Index<Tag>(_unchecked: result.residue)
    }

    @inlinable
    public static func physical(
        forLogical logicalIndex: Index::Index<Tag>,
        head: Index::Index<Tag>,
        capacity: Index::Index<Tag>.Count
    ) -> Index::Index<Tag> {
        precondition(capacity.underlying.rawValue > 0, "Cyclic index capacity must be positive")
        let modulus = Cyclic.Group.Modulus(__unchecked: capacity)
        let headElement = Cyclic.Group.Element(__unchecked: head)
        let logicalElement = Cyclic.Group.Element(__unchecked: logicalIndex)
        let result = Cyclic.Group.add(
            headElement,
            logicalElement,
            modulus: modulus
        )
        return Index::Index<Tag>(_unchecked: result.residue)
    }
}
#endif
