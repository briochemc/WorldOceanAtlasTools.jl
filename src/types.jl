
# TODO 
# 1. Make Observations a subtype of AbstractArrays?
#     This could help for writing `mismatch` in AIBECS
#     but more generally to both easily access a vector of obs and some metadata attached to it
# 2. Make it more of more geenric type .obs and .metadata

"""
    Observations

Observation struct
"""
struct Observations{A,B} <: AbstractVector{A}
    values::Vector{A}
    metadata::B
end

# AbstractArray interface
Base.size(o::Observations) = size(o.values)
Base.getindex(o::Observations, i::Int) = getindex(o.values, i)
Base.setindex!(o::Observations, v, i::Int) = setindex!(o.values, v, i)


function Base.show(io::IO, o::Observations{A,B}) where {A,B}
    preshowobs(o.metadata)
    show(io, o.values)
end
function Base.show(io::IO, m::MIME"text/plain", o::Observations{A,B}) where {A,B}
    preshowobs(o.metadata)
    show(io, m, o.values)
end

preshowobs(::Nothing) = println("Observations")
function preshowobs(MD)
    if haskey(MD, :unit)
        println("Observations of $(MD.name) [$(MD.unit)] (with metadata)")
    else
        println("Observations of $(MD.name) (with metadata)")
    end
end

Base.:*(o::Observations, q::Quantity) = Observations(o.values .* q, o.metadata)
Base.:*(q::Quantity, o::Observations) = o * q
Unitful.upreferred(o::Observations) = Observations(upreferred.(o.values), o.metadata)
Unitful.ustrip(o::Observations) = Observations(ustrip.(o.values), (o.metadata..., unit=unit(eltype(o))))

export Observations
