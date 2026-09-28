#if Index
public import Ordinal
public import Tagged

extension Tagged::Tagged
where Underlying == Ordinal::Ordinal, Tag: ~Copyable & ~Escapable {

    public typealias Cyclic<let N: Int> = Tagged::Tagged<
        Tag,
        Cyclic::Cyclic.Group.Static<N>.Element
    >
}
#endif
