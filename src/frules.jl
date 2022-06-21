function frule((_, Δx), ::Type{Quantity{T,D,U}}, x::Number) where {T,D,U}
    return Quantity{T,D,U}(x), Quantity{T,D,U}(Δx)
end

function frule((_, Δx, _), ::typeof(*), x::Quantity, y::Units)
    return *(x, y), *(Δx , y)
end

function frule((_, Δx, _), ::typeof(/), x::Number, y::Units) 
    return frule((nothing, Δx, nothing), *, x, inv(y))
end
function frule((_, _, Δy), ::typeof(/), x::Units, y::Number)
    return frule((nothing, Δy, nothing), *, inv(y), x)
end