const CommutativeMulQuantity = Quantity{T,D,U} where {T<:Union{Real,Complex}, D, U}
const CommMulVal = Union{Real, Complex, CommutativeMulQuantity}

# Reference: https://github.com/JuliaDiff/ChainRules.jl/blob/148fa8875725a19cf658405609fa1a56671d0cbd/src/rulesets/Base/arraymath.jl

# Defines *, / for the pairs where:
#   1. The scalar is a commutative/mul quantity and the array is real, complex, or a comm/mul quantity
#   2. The scalar is a commutative/mul number and the array is a comm/mul quantity
# We have to be careful defining this so that we always have a Quantity in the signature, otherwise
#   we overwrite methods from ChainRules.jl
for (s_type,a_type) in (
    (:CommutativeMulQuantity, :(<:CommMulVal)), 
    (:(Union{Real,Complex}), :(<:CommutativeMulQuantity))
    )
    @eval function rrule(
       ::typeof(*), A::$(s_type), B::AbstractArray{$(a_type)}
    )
        project_A = ProjectTo(A)
        project_B = ProjectTo(B)
        function times_pullback(ȳ)
            Ȳ = unthunk(ȳ)
            return (
                NoTangent(),
                @thunk(project_A(dot(Ȳ, B)')),
                InplaceableThunk(
                    X̄ -> mul!(X̄, conj(A), Ȳ, true, true),
                    @thunk(project_B(A' * Ȳ)),
                )
            )
        end
        return A * B, times_pullback
    end

    @eval function rrule(
        ::typeof(*), B::AbstractArray{$(a_type)}, A::$(s_type)
    )
        project_A = ProjectTo(A)
        project_B = ProjectTo(B)
        function times_pullback(ȳ)
            Ȳ = unthunk(ȳ)
            return (
                NoTangent(),
                InplaceableThunk(
                    X̄ -> mul!(X̄, conj(A), Ȳ, true, true),
                    @thunk(project_B(A' * Ȳ)),
                ),
                @thunk(project_A(dot(Ȳ, B)')),
            )
        end
        return A * B, times_pullback
    end

    @eval function rrule(::typeof(/), A::AbstractArray{$(a_type)}, b::$(s_type))
        Y = A/b
        function slash_pullback_scalar(ȳ)
            Ȳ = unthunk(ȳ)
            Athunk = InplaceableThunk(
                dA -> dA .+= Ȳ ./ conj(b),
                @thunk(Ȳ / conj(b)),
            )
            bthunk = @thunk(-dot(A,Ȳ) / conj(b^2))
            return (NoTangent(), Athunk, bthunk)
        end
        return Y, slash_pullback_scalar
    end
end
