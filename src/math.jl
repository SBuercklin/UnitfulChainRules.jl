function rrule(::typeof(abs), x::Unitful.Quantity{T,D,U}) where {T<:REALCOMPLEX, D, U}
    Ω = abs(x)
    function abs_pullback(ΔΩ)
        signx = isreal(x) ? sign(x) : x / ifelse(iszero(x), oneunit(Ω), Ω)
        return (NoTangent(), signx * real(ΔΩ))
    end
    return Ω, abs_pullback
end

# Reference from ChainRules.jl
# https://github.com/JuliaDiff/ChainRules.jl/blob/1f4a8a9d86c79f024a911f61aa180bdc094bb8a3/src/rulesets/Base/fastmath_able.jl#L186-L200
function rrule(::typeof(^), x::Quantity{T,D,U}, p::Number) where {T,D,U}
    y = x^p
    project_x = ProjectTo(x)
    project_p = ProjectTo(p)
    function power_pullback(dy)
        _dx = _pow_grad_x(x, p, float(y))
        return (
            NoTangent(), 
            project_x(conj(_dx) * dy),
            # _pow_grad_p contains log, perhaps worth thunking:
            @thunk project_p(conj(_pow_grad_p(x, p, float(y))) * dy)
        )
    end
    return y, power_pullback
end

# Functions for ^ rrule above
_pow_grad_x(x, p, y) = (p * y / x)
function _pow_grad_x(x::Quantity{T,D,U}, p::Real, y) where {T<:Real, D, U}
    return if !iszero(x) || p < 0
        p * y / x
    elseif isone(p)
        one(y)
    elseif iszero(p) || p > 1
        zero(y)
    else
        oftype(y, Inf)
    end
end

_pow_grad_p(x::Quantity{T,D,U}, p, y) where {T,D,U} = y * Quantity{T,D,U}(log(complex(x.val)))
function _pow_grad_p(x::Quantity{T,D,U}, p::Real, y) where {T<:Real, D, U}
    return if !iszero(x)
        y * Quantity{T,D,U}(real(log(complex(x.val))))
    elseif p > 0
        zero(y)
    else
        oftype(y, NaN)
    end
end