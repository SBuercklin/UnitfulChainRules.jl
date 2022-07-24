module UnitfulChainRules

using Unitful
using Unitful: Quantity, Units, NoDims
using ChainRulesCore: NoTangent, @scalar_rule
import ChainRulesCore: rrule, frule, ProjectTo

include("./rrules.jl")
include("./frules.jl")
include("./projection.jl")


include("./extras.jl") # Unitful-specific rules

include("./trig.jl") # sin, cos, tan, etc for degrees

end # module
