using Unitful
using UnitfulChainRules
using ChainRulesCore

@testset "ustrip" begin
	x = 5.0u"m"
	Ω, pb = rrule(ustrip, x)

	@test Ω == 5.0
	@test last(pb(2.0)) == 2.0/u"m"
end

@testset "uconvert" begin
	x = 30.0u"°"
	Ω, pb = rrule(uconvert, u"rad", x)

	@test Ω ≈ (π/6)u"rad"
	@test last(pb(1.0)) ≈ π*u"rad"/180u"°"
end