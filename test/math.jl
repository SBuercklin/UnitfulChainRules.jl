using Unitful
using UnitfulChainRules

using ChainRulesCore

using Zygote

@testset "abs" begin
    z = (1 + im)u"W"
    Ω, pb = Zygote.pullback(abs, z)

    @test Ω ≈ sqrt(2)u"W"
    @test last(pb(1.0)) ≈ (1 + im)/sqrt(2)
end

@testset "^" begin
    for p in (1/3, 1//3)
        @testset "Real Input, $p" begin
            x = 3.0u"W^3"
            Ω, pb = Zygote.pullback(x -> x^p, x)

            @test Ω ≈ x^p
            @test only(pb(1.0)) ≈ p * x^(p-1)
        end
        @testset "Complex input, $p" begin
            z = (3.0 + 0.0im)u"W^3"
            Ω, pb = Zygote.pullback(z -> z^p, z)

            @test Ω ≈ z^p
            @test only(pb(1.0)) ≈ p * z^(p-1)
        end
    end
end