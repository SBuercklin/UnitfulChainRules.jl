using SafeTestsets

using Test

@safetestset "rrules, frules, ProjectTo" begin
    include("./rrules-frules-projection.jl")
end

@safetestset "Trig Operations" begin
    include("./trig.jl")
end

@safetestset "Extras" begin
    include("./extras.jl")
end

@safetestset "Math" begin
    include("./math.jl")
end

@safetestset "Array Math" begin
    include("./arraymath.jl")
end