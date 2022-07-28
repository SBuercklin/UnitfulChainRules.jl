###########################
#=
    Trigonometric Rules for Degrees

    Let dx be differential in radians/dimensionless, dx° be in degrees
    df/dx° = df/dx * dx/dx° = df/dx * π/180°
=#
###########################
const DEGREE_QUANTITY = Quantity{<:Number,NoDims,typeof(u"°")}
const TO_RAD = π/180u"°"

@scalar_rule sin(x::DEGREE_QUANTITY) cos(x) * TO_RAD
@scalar_rule cos(x::DEGREE_QUANTITY) -sin(x) * TO_RAD
@scalar_rule tan(x::DEGREE_QUANTITY) (1 + Ω^2) * TO_RAD
@scalar_rule csc(x::DEGREE_QUANTITY) -Ω * cot(x) * TO_RAD
@scalar_rule sec(x::DEGREE_QUANTITY) Ω * tan(x) * TO_RAD
@scalar_rule cot(x::DEGREE_QUANTITY) -(1 + Ω^2) * TO_RAD
