module WorldOceanAtlasTools

using DataDeps, NetCDF, Match, Memoize, StatsBase, Unitful

include("WOA13_names.jl")
include("WOA13_interpolations.jl")
include("WOA_units_to_Unitful.jl")

#=====================================
    TODO list?
=====================================#

# - Make a loop and register everything
#    (Only the data to be read or info'd will be downloaded.)
# - Update to WOA 2018

end # module
