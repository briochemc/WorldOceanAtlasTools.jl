
"""
    get_3D_field(product_year, tracer, period, resolution, field)

Downloads and returns the 3D field of a tracer from the World Ocean Atlas.

Availabe product years are 2009, 2013, and 2018.
(2018 more likely to work.)
Tracers are either "phosphate", "nitrate", or "silicate".
Resolution is either "5°", "1°", or "0.25°".
(1° most likely to work.)
Fields are "mean" or "objectively analyzed climatology".
(mean most likely to work.)
Note WOA's nomenclature should work too, e.g., 
"p" for "phosphate", "mn" for "mean", and so on.
"""
function get_3D_field(product_year, tracer, period, resolution, field)
    println("Getting the 3D field of WOA$(my_product_year(product_year)) $(my_averaging_period(period)) $(WOA_path_varname(tracer)) $(surface_grid_size(resolution)) data")
    ds = WOA_Dataset(product_year, tracer, period, resolution)
    field3D = ds[WOA_varname(tracer, field)][:][:, :, :, 1]
    println("  Rearranging data")
    field3D = permutedims(field3D, [2 1 3])
    return field3D
end

function get_gridded_3D_field(ds, tracer, field)
    println("  Reading NetCDF file")
    field3D = ds[WOA_varname(tracer, field)][:][:, :, :, 1]
    lon   = ds["lon"][:]
    lat   = ds["lat"][:]
    depth = ds["depth"][:]
    println("  Rearranging data")
    # Reorder the variable index order (lat <-> lon from WOA to OCIM)
    field3D = permutedims(field3D, [2 1 3])
    # Rearrange longitude range (from WOA data, which is -180:180, to 0:360)
    lon = mod.(lon, 360)
    lon_reordering = sortperm(lon)
    lon = lon[lon_reordering]
    field3D .= field3D[:, lon_reordering, :]
    return field3D, lat, lon, depth
end

function filter_gridded_3D_field(field3D, lat, lon, depth)
    # Find where there is data for both mean and std
    println("  Filtering data")
    CI = findall(.~ismissing.(field3D) .& (field3D .≠ 0)) # filter out fill-values and 0's
    fieldvec = field3D[CI]
    latvec = lat[map(x -> x.I[1], CI)]
    lonvec = lon[map(x -> x.I[2], CI)]
    depthvec = depth[map(x -> x.I[3], CI)]
    return fieldvec, latvec, lonvec, depthvec, CI
end

get_unit(ds, tracer, field) = convert_to_Unitful(ds[WOA_varname(tracer, field)].attrib["units"])

function mean_and_variance_gridded_3d_field(grid::OceanGrid, field3D, lat, lon, depth)
    fieldvec, latvec, lonvec, depthvec, CI = filter_gridded_3D_field(field3D, lat, lon, depth)
    println("  Averaging data over each grid box")
    χ_3D = zeros(size(grid))
    σ²_3D = zeros(size(grid))
    n_3D = zeros(size(grid))
    # Use NearestNeighbors to bin into OceanGrid
    gridbox_centers = [ustrip.(vec(grid.lat_3D)) ustrip.(vec(grid.lon_3D)) ustrip.(vec(grid.depth_3D))] # TODO Maybe add option for using iwet instead of full vec
    gridbox_centers = permutedims(gridbox_centers, [2, 1])
    kdtree = KDTree(gridbox_centers)
    for i in eachindex(CI)
        idx = knn(kdtree, [lonvec[i], latvec[i], depthvec[i]], 1, true)[1][1]
        χ_3D[idx] += fieldvec[i]      # μ = Σᵢ μᵢ / n
        σ²_3D[idx] += fieldvec[i]^2   # σ² = Σᵢ μᵢ² / n - μ²
        n_3D[idx] += 1
    end
    χ_3D .= χ_3D ./ n_3D               # μ = Σᵢ μᵢ / n
    σ²_3D .= σ²_3D ./ n_3D .- χ_3D.^2  # σ² = Σᵢ μᵢ² / n - μ²
    # Enforce μ = 0 and σ = ∞ where no observations
    # (Instead of NaNs)
    println("  Setting μ = 0 and σ² = ∞ where no obs")
    χ_3D[findall(n_3D .== 0)] .= 0.0
    σ²_3D[findall(n_3D .== 0)] .= Inf
    println("  Setting a realistic minimum for σ²")
    meanχ = mean(χ_3D, weights(n_3D))
    σ²_3D .= max.(σ²_3D, 1e-4meanχ^2)
    return χ_3D, σ²_3D
end

function convert_to_SI_unit!(χ_3D, σ²_3D, ds, tracer, field)
    # Convert to SI units
    χ_unit = get_unit(ds, tracer, field)
    χ_3D .*= ustrip(upreferred(1.0χ_unit))
    σ²_3D .*= ustrip(upreferred(1.0χ_unit^2))
end

function fit_to_grid(grid::OceanGrid, product_year, tracer, period, resolution, field)
    ds = WOA_Dataset(product_year, tracer, period, resolution)
    field3D, lat, lon, depth = get_gridded_3D_field(ds, tracer, field)
    χ_3D, σ²_3D = mean_and_variance_gridded_3d_field(grid, field3D, lat, lon, depth)
    convert_to_SI_unit!(χ_3D, σ²_3D, ds, tracer, field)
    return χ_3D, σ²_3D
end

#==================================
Helper functions
==================================#

function WOA_Dataset(product_year, tracer, period, resolution; verbose=false)
    println("Registering WOA data with DataDeps")
    verbose && print(": ", url_WOA_THREDDS(product_year, tracer, period, resolution))
    register_WOA(product_year, tracer, period, resolution)
    ddstr = @datadep_str string(my_DataDeps_name(product_year, tracer, period, resolution),
                        "/", 
                        WOA_NetCDF_filename(product_year, tracer, period, resolution))
    Dataset(ddstr)
end

function remove_DataDep(product_year, tracer, period, resolution)
    println("Removing WOA$(my_product_year(product_year)) $(my_averaging_period(period)) $(WOA_path_varname(tracer)) $(surface_grid_size(resolution)) data")
    nc_file = @datadep_str string(my_DataDeps_name(product_year, tracer, period, resolution), "/", WOA_NetCDF_filename(product_year, tracer, period, resolution))
    rm(nc_file; recursive=true, force=true)
end

