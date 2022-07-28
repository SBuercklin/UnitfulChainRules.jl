using Unitful
using UnitfulChainRules

using ChainRulesCore

using Random
rng = VERSION >= v"1.7" ? Random.Xoshiro(0x0451) : Random.MersenneTwister(0x0451)

dsin(Ω, x) = cos(x)
dcos(Ω, x) = -sin(x)
dtan(Ω, x) = 1 + Ω^2
dcsc(Ω, x) = - Ω * cot(x)
dsec(Ω, x) = Ω * tan(x)
dcot(Ω, x) = -(1 + Ω^2)

for (f, df) in (
	(:sin, :dsin), (:cos,:dcos), (:tan,:dtan), (:csc,:dcsc), (:sec,:dsec), (:cot,:dcot)
	)
	eval(
		quote
			@testset "$($f)" begin
				x = rand(rng)u"°"

				Ω, pb = rrule($f, x)
				@test Ω == $f(x)
				@test last(pb(1.0)) ≈ $df(Ω, x) * π/180u"°"
			end
		end
	)
end