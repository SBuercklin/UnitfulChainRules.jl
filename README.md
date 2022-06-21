# UnitfulChainRules.jl

`UnitfulChainRules.jl` adds support for differentiating through scalar `Unitful.Quantity` construction and arithmetic. The arithmetic rules are drawn from the existing `ChainRules.jl` scalar rules, so this package provides the `Quantity` autodiff rules and utilities.

Right now, this includes `rrule, frule` implementations for the `Quantity` construction and the `ProjectTo` utility. We implement projection onto `Quantity`s and projection of `Quantity`s onto `Real, Complex` numbers.

## Usage

To import the rules, all that is required is importing `UnitfulChainRules.jl` in addition to `Unitful.jl`. 

```julia
using Unitful: W, μm, ms
using UnitfulChainRules
using Zygote

Zygote.gradient((x,y) -> (x*W)/(y*μm)/ms, 3.0*W, 2.0*μm)
# (0.5 W μm^-2 ms^-1, -0.75 W^2 μm^-3 ms^-1)

Zygote.gradient((x,y) -> (x*ms + 9*y*ms)/μm, 2.0*W, 3.0*W)
# (1.0 ms μm^-1, 9.0 ms μm^-1)
```

## Array Rules

This package does not yet include compatibility for operations between arrays of `Unitful.Quantity`s, like most `LinearAlgebra` ops. [An issue](https://github.com/SBuercklin/UnitfulChainRules.jl/issues/5) is open for discussing how to best add array rules.