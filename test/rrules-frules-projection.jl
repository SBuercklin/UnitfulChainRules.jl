using Unitful
using UnitfulChainRules

using ChainRulesCore: frule, rrule, ProjectTo, NoTangent

using Zygote

using Random
rng = VERSION >= v"1.7" ? Random.Xoshiro(0x0451) : Random.MersenneTwister(0x0451)

@testset "ProjectTo" begin
    real_test(proj, val) = proj(val) == real(val)
    complex_test(proj, val) = proj(val) == val
    ru = randn(rng)
    ruval = ru*u"W"
    p_ruval = ProjectTo(ruval)

    cu = randn(rng, ComplexF64)
    cuval = cu*u"kg"
    p_cuval = ProjectTo(cuval)

    p_real = ProjectTo(ru)
    p_complex = ProjectTo(cu)

    δr = randn(rng)
    δrval = δr*u"m"

    δc = randn(rng, ComplexF64)
    δcval = δc*u"L"

    # Test projection onto real unitful quantities
    for δ in (δrval, δcval, ru, cu)
        @test real_test(p_ruval, δ)
    end

    # Test projection onto complex unitful quantities
    for δ in (δrval, δcval, ru, cu)
        @test complex_test(p_cuval, δ)
    end 

    # Projecting Unitful quantities onto real values
    @test p_real(δrval) == δrval
    @test p_real(δcval) == real(δcval)

    # Projecting Unitful quantities onto complex values
    @test p_complex(δrval) == δrval
    @test p_complex(δcval) == δcval
end

@testset "rrules" begin
    @testset "Quantity rrule" begin
        UT = typeof(1.0*u"W")
        x = randn(rng)
        δx = randn(rng)
        Ω, pb = Zygote.pullback(UT, x)
        @test Ω == x * u"W"
        @test only(pb(δx)) == δx * u"W"
    end
    @testset "* rrule" begin
        x = randn(rng)*u"W" 
        y = u"m"
        z = u"L"
        Ω, pb = Zygote.pullback(*, x, y, z)
        @test Ω == x*y*z
        δ = randn(rng)
        @test pb(δ) == (δ*y*z, nothing, nothing)
    end
end

@testset "frules" begin
    @testset "Quantity frule" begin
        UT = typeof(1.0*u"W")
        x = randn(rng)
        δx = randn(rng)
        X, ∂X = frule((nothing, δx), UT, x)
        @test X == x * u"W"
        @test ∂X == δx * u"W"
    end
    @testset "* frule" begin
        x = randn(rng)*u"W" 
        δx = randn(rng)*u"L"
        y = u"m"
        X, ∂X = frule((nothing, δx, nothing), *, x, y)
        @test X == x*y
        @test ∂X == δx*y
    end
end