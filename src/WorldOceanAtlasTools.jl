module WorldOceanAtlasTools

using DataDeps, NetCDF, Match, Interpolations, Inpaintings

include("WOA13_names.jl")
include("WOA13_interpolations.jl")

# Test with `ncinfo(datadep"WOA13/woa13_all_p00_01.nc")`

# TODO 

# - Make a loop and register everything
#    (Only the data to be read or info'd will be downloaded.)
#

end # module
