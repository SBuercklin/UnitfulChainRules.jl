function (projector::ProjectTo{<:Quantity})(x::Number)
    new_val = projector.project_val(ustrip(x))
    return new_val*unit(x)
end

# Project Unitful Quantities onto numerical types by projecting the value and carrying units
ProjectTo(x::Quantity) = ProjectTo(x.val)

(project::ProjectTo{<:Real})(dx::Quantity) = project(ustrip(dx))*unit(dx)
(project::ProjectTo{<:Complex})(dx::Quantity) = project(ustrip(dx))*unit(dx)