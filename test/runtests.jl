
using Test, WorldOceanAtlasTools
using NCDatasets

# Alias for short name
WOAT = WorldOceanAtlasTools

# For CI, make sure the download does not hang
ENV["DATADEPS_ALWAYS_ACCEPT"] = true

@testset "Testing OPeNDAP" begin
    #years = [2009, 2013, 2018] # years of WOA products
    #years = [2009, 2018] # years of WOA products with OPeNDAP workign URLs
    years = [2018] # just test 2018 links, tough luck for the other ones...
    vvs = ["p", "i", "n"] # nutrients only
    tts = [0, 1, 13] # Annual, 1 month and 1 season — no need to test every month and season
    ggs = ["5°", "1°"]
    ffs = ["mn", "an"]

    @testset "WOA$(WOAT.my_year(year))" for year in years
        @testset "$gg x $gg grid" for gg in ggs
            @testset "$(WOAT.my_averaging_period(tt)) period" for tt in tts
                @testset "$(WOAT.WOA_path_varname(vv)) tracer" for vv in vvs
                    ds = Dataset(WOAT.NetCDF_path(year, vv, tt, gg))
                    @testset "$ff field" for ff in ffs
                        if gg ≠ "5°" || ff ≠ "an"
                            @test haskey(ds, WOAT.WOA_varname(vv, ff))
                        end
                    end
                    @testset "dimensions" begin
                        @test haskey(ds, "lat")
                        @test haskey(ds, "lon")
                        @test haskey(ds, "depth")
                    end
                end
            end
        end
    end
end