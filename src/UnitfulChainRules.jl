module UnitfulChainRules

using Unitful
using Unitful: Quantity, Units, NoDims, FreeUnits
using ChainRulesCore
import ChainRulesCore: rrule, frule, ProjectTo
using LinearAlgebra

const REALCOMPLEX = Union{Real, Complex}

include("./rrules.jl")
include("./frules.jl")
include("./projection.jl")


include("./extras.jl") # extra Unitful-specific rules

include("./trig.jl") # sin, cos, tan, etc for degrees

include("./math.jl") # other math 

include("./arraymath.jl") # Simple scalar-array math

end # module
