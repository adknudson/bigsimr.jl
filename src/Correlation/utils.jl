"""
    cor(x, ::Type{<:Correlation})

Compute the correlation matrix. The possible correlation
    types are Pearson, Spearman, or Kendall.
"""
function cor end

cor(x,    ::Type{Pearson})  = cor(x)
cor(x, y, ::Type{Pearson})  = cor(x, y)
cor(x,    ::Type{Spearman}) = corspearman(x)
cor(x, y, ::Type{Spearman}) = corspearman(x, y)
cor(x,    ::Type{Kendall})  = corkendall(x)
cor(x, y, ::Type{Kendall})  = corkendall(x, y)
# cor(x::AbstractVector, ::Correlation) = cor(x)

"""
    cor_convert(ρ::Real, from::Correlation, to::Correlation)

Convert from one type of correlation matrix to another. The possible correlation
types are Pearson, Spearman, or Kendall.
"""
function cor_convert end
cor_convert(ρ, from::Type{C}, to::Type{C}) where {C<:Correlation} = ρ
cor_convert(ρ, from::Type{Pearson},  to::Type{Spearman}) = (6 / π) * asin(ρ / 2)
cor_convert(ρ, from::Type{Pearson},  to::Type{Kendall})  = (2 / π) * asin(ρ)
cor_convert(ρ, from::Type{Spearman}, to::Type{Pearson})  = 2 * sin(ρ * π / 6)
cor_convert(ρ, from::Type{Spearman}, to::Type{Kendall})  = (2 / π) * asin(2 * sin(ρ * π / 6))
cor_convert(ρ, from::Type{Kendall},  to::Type{Pearson})  = sin(ρ * π / 2)
cor_convert(ρ, from::Type{Kendall},  to::Type{Spearman}) = (6 / π) * asin(sin(ρ * π / 2) / 2)
cor_convert(R::AbstractMatrix, from::Type{Correlation}, to::Type{Correlation}) = cor_convert.(copy(R), from, to)


function cor_constrain(C::AbstractMatrix)
    C = clampcor.(C)
    C[diagind(C)] .= one(eltype(C))

    return Matrix{eltype(C)}(Symmetric(C))
end


function cov2cor(C::AbstractMatrix)
    D = pinv(diagm(sqrt.(diag(C))))
    return cor_constrain(D * C * D)
end


function cor_bounds(dA::UD, dB::UD, C::Type{<:Correlation}; n::Int=100000)
    a = rand(dA, n)
    b = rand(dB, n)

    upper = cor(sort!(a), sort!(b), C)
    lower = cor(a, reverse!(b), C)

    return (lower = lower, upper = upper)
end

function cor_bounds(D::MvDistribution)
    d = length(D.F)

    lower, upper = similar(cor(D)), similar(cor(D))

    @threads for i in collect(subsets(1:d, Val{2}()))
        l, u = cor_bounds(D.F[i[1]], D.F[i[2]])
        lower[i...] = l
        upper[i...] = u
    end

    lower .= cor_constrain(Matrix{eltype(D)}(Symmetric(lower)))
    upper .= cor_constrain(Matrix{eltype(D)}(Symmetric(upper)))

    (lower = lower, upper = upper)
end