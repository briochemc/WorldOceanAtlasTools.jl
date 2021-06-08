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
#include("interpolations.jl")
include("convert_to_Unitful.jl")
include("functions.jl")

#=====================================
    TODO list?
=====================================#

# - Make a loop and register everything
#    (Only the data to be read or info'd will be downloaded.)
# - Update to WOA 2018

end # module
