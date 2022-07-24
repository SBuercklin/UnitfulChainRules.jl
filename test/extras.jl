using Unitful
using UnitfulChainRules
using ChainRulesCore

@testset "ustrip" begin
	x = 5.0u"m"
	Ω, pb = rrule(ustrip, x)

	@test Ω == 5.0
	@test last(pb(2.0)) == 2.0/u"m"
end