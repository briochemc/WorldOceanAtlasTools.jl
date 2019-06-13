
using Test, WorldOceanAtlasTools
using NCDatasets
using OceanGrids, Unitful

# Alias for short name
WOA = WorldOceanAtlasTools

# For CI, make sure the download does not hang
ENV["DATADEPS_ALWAYS_ACCEPT"] = true

# include("test_urls.jl") # Only include locally, as it URLs randomly fail
include("test_functions.jl")
include("test_citations.jl")

