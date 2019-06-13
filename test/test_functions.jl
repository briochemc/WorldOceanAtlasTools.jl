

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
        grid = OceanGrid(90,180,24)
        a, b = WOA.fit_to_grid(grid, product_year, tracer, period, resolution, field)
        println(typeof(a))
        println(typeof(b))
        @test a isa Array{Float64, 3}
        @test size(a) == size(grid)
        @test b isa Array{Float64, 3}
        @test size(b) == size(grid)
        I = findall(a .≠ 0)
        @test 1e-3 < sum(a[I]) / length(I) < 3e-3 # mean PO₄ ≈ 2e-3 mol m⁻³
    end
end
