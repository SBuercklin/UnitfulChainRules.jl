using Unitful
using UnitfulChainRules

using Zygote

using Random
rng = VERSION >= v"1.7" ? Random.Xoshiro(0x0451) : Random.MersenneTwister(0x0451)

@testset "Array-Scalar Multiplication" begin
    for (a_unit, s_unit) in ((1.0,oneunit(1.0u"m")), (oneunit(1.0u"m"), 1.0))
        A = randn(rng, 5) * a_unit
        s = randn(rng) * s_unit

        @testset "A * s ($a_unit, $s_unit)" begin
            Ω, pb = Zygote.pullback(*, A, s)

            @test Ω ≈ A * s
            @test all(first(pb(one.(Ω))) .≈ s)
            @test last(pb(one.(Ω))) ≈ sum(A)
        end

        @testset "s * A ($s_unit, $a_unit)" begin

            Ω, pb = Zygote.pullback(*, s, A)

            @test Ω ≈ s * A
            @test all(last(pb(one.(Ω))) .≈ s)
            @test first(pb(one.(Ω))) ≈ sum(A)
        end
    end
end

@testset "Array-Scalar Division" begin
    for (a_unit, s_unit) in ((1.0,oneunit(1.0u"m")), (oneunit(1.0u"m"), 1.0))
        @testset "($a_unit, $s_unit) division" begin
            A = randn(rng, 5) * a_unit
            s = randn(rng) * s_unit

            Ω, pb = Zygote.pullback(/, A, s)

            @test Ω ≈ A / s
            @test all(first(pb(one.(Ω))) .≈ inv(s))
            @test last(pb(one.(Ω))) ≈ -sum(A)/s^2
        end
    end
end