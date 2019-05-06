using Documenter, WorldOceanAtlasTools

makedocs(
    sitename="WorldOceanAtlasTools Documentation",
    # options
    modules = [WorldOceanAtlasTools]
)

deploydocs(
    repo = "github.com/briochemc/WorldOceanAtlasTools.jl.git",
)