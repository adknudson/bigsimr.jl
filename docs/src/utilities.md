# Utilities

## General Utilities

```@docs
MvSim.hermite(x::Real, n::Int; probabilists::Bool=true)
MvSim.setdiag(A::Matrix{<:Real}, x::Real)
MvSim.normal_to_margin(d::UnivariateDistribution, x::AbstractArray)
```

## Pearson Matching Utilities

```@docs
MvSim.get_coefs(margin::UnivariateDistribution, n::Int)
MvSim.Hϕ(x::Real, n::Int)
MvSim.Gn0d(n::Int, A, B, α, β, σAσB_inv)
MvSim.Gn0m(n::Int, A, α, dB, σAσB_inv)
MvSim.solve_poly_pm_one(coef)
```

## Nearest Positive Definite Correlation Matrix Utilities

```@docs
MvSim.npd_gradient(y::Vector{Float64}, λ₀::Vector{Float64}, P::Matrix{Float64}, b₀::Vector{Float64}, n::Int)
MvSim.npd_pca(X::Matrix{Float64}, λ::Vector{Float64}, P::Matrix{Float64}, n::Int)
MvSim.npd_pre_cg(b::Vector{Float64}, c::Vector{Float64}, Ω₀::Matrix{Float64}, P::Matrix{Float64}, ϵ::Float64, N::Int, n::Int)
MvSim.npd_precond_matrix(Ω₀::Matrix{Float64}, P::Matrix{Float64}, n::Int)
MvSim.npd_set_omega(λ::Vector{Float64}, n::Int)
MvSim.npd_jacobian(x::Vector{Float64}, Ω₀::Matrix{Float64}, P::Matrix{Float64}, n::Int; PERTURBATION::Float64=1e-9)
```
