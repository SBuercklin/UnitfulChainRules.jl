# Identity operation for non-Quantities
rrule(::typeof(ustrip), x::Number) = x, (Δ) -> (NoTangent(), Δ * one(x))

# Divide by the stripped units to backprop
function rrule(::typeof(ustrip), x::Quantity{T,D,U}) where {T,D,U}
    ustripped = ustrip(x)
    project_x = ProjectTo(x)
    invU = inv(U())

    ustrip_pb(Δ) = (NoTangent(), project_x(Δ * invU))

    return ustripped, ustrip_pb
end

function rrule(::typeof(uconvert), u::FreeUnits{N,D,A}, x::TX) where {N,D,A,TX}
    x_convert = uconvert(u, x)
    conversion = uconvert(u, oneunit(x)) / oneunit(x)
    project_x = ProjectTo(x)

    function uconvert_pb(Δ)
        return (NoTangent(), NoTangent(), project_x(Δ * conversion))
    end
    
    return x_convert, uconvert_pb
end