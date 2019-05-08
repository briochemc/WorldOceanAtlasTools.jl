


@testset "Testing URLs" begin
    years = [2009, 2013, 2018] # WOA product years
    vvs = ["p", "i", "n"] # nutrients only
    tts = [0, 1, 13] # Annual, 1 month and 1 season — no need to test every month and season
    ggs = ["5°", "1°", "0.25°"]
    ffs = ["mn", "an", "sd", "se"]

    @testset "WOA$(WOA.my_year(year))" for year in years
        @testset "$gg x $gg grid" for gg in ggs
            @testset "$(WOA.my_averaging_period(tt)) period" for tt in tts
                @testset "$(WOA.WOA_path_varname(vv)) tracer" for vv in vvs
                    ds = Dataset(WOA.NetCDF_path(year, vv, tt, gg))
                    @testset "$ff field" for ff in ffs
                        @test haskey(ds, WOA.WOA_varname(vv, ff))
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