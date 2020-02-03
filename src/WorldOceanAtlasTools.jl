module WorldOceanAtlasTools

using DataDeps, NCDatasets, Match, Statistics, StatsBase, Unitful
using OceanGrids, NearestNeighbors

include("types.jl")
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
