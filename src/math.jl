function rrule(::typeof(abs), x::Unitful.Quantity{T,D,U}) where {T<:REALCOMPLEX, D, U}
    Ω = abs(x)
    function abs_pullback(ΔΩ)
        signx = isreal(x) ? sign(x) : x / ifelse(iszero(x), oneunit(Ω), Ω)
        return (NoTangent(), signx * real(ΔΩ))
    end
    return Ω, abs_pullback
end