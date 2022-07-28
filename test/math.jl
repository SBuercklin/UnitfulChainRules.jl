using Unitful
using UnitfulChainRules

using ChainRulesCore

@testset "abs" begin
    z = (1 + im)u"W"
    Ω, pb = rrule(abs, z)

    @test Ω ≈ sqrt(2)u"W"
    @test last(pb(1.0)) ≈ (1 + im)/sqrt(2)
end