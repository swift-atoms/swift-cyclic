import Cardinal
import Cyclic
import Difference
import Index
import Ordinal

struct First: ~Copyable, ~Escapable {}
struct Second: ~Copyable, ~Escapable {}

#if MISMATCH_OFFSET
typealias OffsetDomain = Second
#else
typealias OffsetDomain = First
#endif

#if MISMATCH_CAPACITY
typealias CapacityDomain = Second
#else
typealias CapacityDomain = First
#endif

let position = Index<First>(Ordinal(2))
let offset = Index<OffsetDomain>.Offset(-1)
let capacity = Index<CapacityDomain>.Count(Cardinal(5))
let result = Index<First>.Modular.advanced(position, by: offset, capacity: capacity)
