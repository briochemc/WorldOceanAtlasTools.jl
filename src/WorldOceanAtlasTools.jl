module WorldOceanAtlasTools

using DataDeps
using Downloads
using NCDatasets
using DataFrames
using Match
using Statistics
using StatsBase
using Unitful
using OceanGrids
using NearestNeighbors

include("names.jl")
include("citations.jl")
include("convert_to_Unitful.jl")
include("functions.jl")

end # module
