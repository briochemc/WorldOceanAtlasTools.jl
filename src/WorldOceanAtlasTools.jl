module WorldOceanAtlasTools

using DataDeps, NCDatasets, Match, Memoize, StatsBase, Unitful

include("names.jl")
include("citations.jl")
include("interpolations.jl")
include("WOA_units_to_Unitful.jl")
include("arrays.jl")

#=====================================
    TODO list?
=====================================#

# - Make a loop and register everything
#    (Only the data to be read or info'd will be downloaded.)
# - Update to WOA 2018

end # module
