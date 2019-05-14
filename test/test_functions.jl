# Functions to create small grid
macro Dict(vars...)
    kvs = Expr.(:call, :Pair, string.(vars), esc.(vars))
    Expr(:call, :Dict, kvs...)
end
function build_grd()
    wet3d = trues(2, 1, 3)
    # From Archer et al. [2000]
    vtot = 1.292e18     # m³
    area_ocean = 349e12 # m²
    depth_low = 100.0  # m
    depth_high = 250.0 # m
    fraction_area_high = 0.15 #
    # Infer other values
    depth_ocean = vtot / area_ocean
    # Build DY3d
    earth_perimeter = 40e6 # 40'000 km
    DYocean = earth_perimeter / 2 # distance from south pole to north pole
    DYhigh = fraction_area_high * DYocean
    DYlow = (1 - fraction_area_high) * DYocean
    DYT3d = zeros(size(wet3d))
    DYT3d[1, :, :] .= DYhigh
    DYT3d[2, :, :] .= DYlow
    # Build DZ3d
    DZT3d = zeros(size(wet3d))
    DZT3d[:, :, 1] .= depth_low
    DZT3d[:, :, 2] .= depth_high - depth_low
    DZT3d[:, :, 3] .= depth_ocean - depth_high
    # Build DX3d
    DXT3d = vtot / (depth_ocean * DYocean) * ones(size(wet3d))
    # ZT3d
    ZT3d = cumsum(DZT3d, dims=3) - DZT3d / 2
    # ZW3d (depth at top of box)
    ZW3d = cumsum(DZT3d, dims=3) - DZT3d
    # lat, lon, depth
    dxt = [360.0]
    xt = dxt / 2
    dyt = [fraction_area_high * 180, (1 - fraction_area_high) * 180]
    yt = -90.0 .+ cumsum(dyt) .- dyt/2
    dzt = DZT3d[1, 1, :]
    zt = cumsum(dzt) .- dzt/2
    return @Dict DXT3d DYT3d DZT3d ZW3d ZT3d dxt xt dyt yt dzt zt
end

@testset "Testing functions" begin
    product_year = 2018
    tracer = "p"
    period = 0 # Annual, 1 month and 1 season — no need to test every month and season
    resolution = "5°"
    field = "mn"
    ds = WOA.WOA_Dataset(product_year, tracer, period, resolution)
    @test ds isa Dataset
    @testset "get_3D_field" begin
        field3D = WOA.get_3D_field(product_year, tracer, period, resolution, field)
        @test field3D isa Array{Union{Float32, Missing},3}
        @test size(field3D) == (36, 72, 102)
    end
    @testset "get_gridded_3D_field" begin
        field3D, lat, lon, depth = WOA.get_gridded_3D_field(ds, tracer, field)
        @test field3D isa Array{Union{Float32, Missing},3}
        @test size(field3D) == (36, 72, 102)
        @test lat isa Vector
        @test length(lat) == 36
        @test lon isa Vector
        @test length(lon) == 72
        @test depth isa Vector
        @test length(depth) == 102
    end
    @testset "filter_gridded_3D_field" begin
        field3D, lat, lon, depth = WOA.get_gridded_3D_field(ds, tracer, field)
        fieldvec, latvec, lonvec, depthvec, CI = WOA.filter_gridded_3D_field(field3D, lat, lon, depth)
        @test fieldvec isa Vector
        @test latvec isa Vector
        @test lonvec isa Vector
        @test depthvec isa Vector
    end
    @testset "fit_to_grid" begin
        grd = build_grd()
        a, b = WOA.fit_to_grid(grd, product_year, tracer, period, resolution, field)
        println(typeof(a))
        println(typeof(b))
        @test a isa Array{Float64, 3}
        @test size(a) == (2,1,3)
        @test b isa Array{Float64, 3}
        @test size(b) == (2,1,3)
        @test 1e-3 < sum(a) / length(a) < 3e-3 # mean PO₄ ≈ 2e-3 mol m⁻³
    end
end
