
"""
    get_3D_field(tracer; product_year=2018, period=0, resolution=1, field="an")

Downloads and returns the 3D field of a tracer from the World Ocean Atlas.

Tracers are either "phosphate", "nitrate", or "silicate".
Availabe product years are 2009, 2013, and 2018 (default: 2018).
Resolution is either "5°", "1°", or "0.25°" (default: 1°).
Fields are "mean" or "an" (for objectively analyzed climatology).
(default = "an".)

Note that WOA's nomenclature should work too, e.g.,
"p" for "phosphate", "mn" for "mean", and so on.
"""
function get_3D_field(tracer; product_year=2018, period=0, resolution=1, field="an")
    println("Getting the 3D field of WOA$(my_product_year(product_year)) $(my_averaging_period(period)) $(WOA_path_varname(tracer)) $(surface_grid_size(resolution)) data")
    ds = WOA_Dataset(tracer; product_year, period, resolution)
    field3D = ds[WOA_varname(tracer, field)][:][:, :, :, 1]
    println("  Rearranging data")
    field3D = permutedims(field3D, [2 1 3])
    return field3D
end

function get_gridded_3D_field(ds, tracer, field)
    println("  Reading NetCDF file")
    field3D = ds[WOA_varname(tracer, field)][:][:, :, :, 1]
    lon   = ds["lon"][:]   .|> Float64
    lat   = ds["lat"][:]   .|> Float64
    depth = ds["depth"][:] .|> Float64
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
function get_gridded_3D_field(tracer, field; kwargs...)
    return Dataset(WOAfile(tracer=tracer; kwargs...), "r") do ds
        get_gridded_3D_field(ds, tracer, field)
    end
end

"""
    mean_std_and_number_obs(ds, tracer)

Returns a DataFrame containing the following columns
lat, lon, depth, mean, std, nobs
"""
function mean_std_and_number_obs(ds, tracer)
    println("  Reading NetCDF file")
    lon   = mod.(ds["lon"][:] .|> Float64, 360)
    lat   = ds["lat"][:]   .|> Float64
    depth = ds["depth"][:] .|> Float64
    μ3D    = ds[WOA_varname(tracer, "mn")][:][:, :, :, 1]
    σ3D    = ds[WOA_varname(tracer, "sd")][:][:, :, :, 1]
    nobs3D = ds[WOA_varname(tracer, "dd")][:][:, :, :, 1]
    println("  Filtering missing data")
    CI = findall(@. !ismissing(μ3D) & !ismissing(nobs3D) & !iszero(nobs3D))
    lon1D   = lon[map(x -> x.I[1], CI)]
    lat1D   = lat[map(x -> x.I[2], CI)]
    depth1D = depth[map(x -> x.I[3], CI)]
    μ1D     = μ3D[CI] .|> Float64
    σ1D     = σ3D[CI] .|> Float64
    nobs1D  = nobs3D[CI] .|> Int64
    return DataFrame(
                     :Latitude => lat1D,
                     :Longitude => lon1D,
                     :Depth => depth1D,
                     :Mean => μ1D,
                     :Std => σ1D,
                     :n_obs => nobs1D,
                    )
end








function filter_gridded_3D_field(field3D, lat, lon, depth)
    # Find where there is data for both mean and std
    println("  Filtering data")
    CI = findall(x -> !ismissing(x) && !iszero(x), field3D) # filter out fill-values and 0's
    fieldvec = field3D[CI]
    latvec = lat[map(x -> x.I[1], CI)]
    lonvec = lon[map(x -> x.I[2], CI)]
    depthvec = depth[map(x -> x.I[3], CI)]
    return fieldvec, latvec, lonvec, depthvec, CI
end

get_unit(ds, tracer, field) = convert_to_Unitful(ds[WOA_varname(tracer, field)].attrib["units"])






function mean_and_variance_gridded_3d_field(grid::OceanGrid, field3D, lat, lon, depth)
    χ_3D, σ²_3D, n_3D = raw_mean_and_variance_gridded_3d_field(grid, field3D, lat, lon, depth)
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

function raw_mean_and_variance_gridded_3d_field(grid::OceanGrid, field3D, lat, lon, depth)
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
        idx = knn(kdtree, [latvec[i], lonvec[i], depthvec[i]], 1, true)[1][1]
        χ_3D[idx] += fieldvec[i]      # μ = Σᵢ μᵢ / n
        σ²_3D[idx] += fieldvec[i]^2   # σ² = Σᵢ μᵢ² / n - μ²
        n_3D[idx] += 1
    end
    χ_3D .= χ_3D ./ n_3D               # μ = Σᵢ μᵢ / n
    σ²_3D .= σ²_3D ./ n_3D .- χ_3D.^2  # σ² = Σᵢ μᵢ² / n - μ²
    return χ_3D, σ²_3D, n_3D
end

function convert_to_SI_unit!(χ_3D, σ²_3D, ds, tracer, field)
    # Convert to SI units
    χ_unit = get_unit(ds, tracer, field)
    χ_3D .*= ustrip(upreferred(1.0χ_unit))
    σ²_3D .*= ustrip(upreferred(1.0χ_unit^2))
end


"""
    fit_to_grid(grid, tracer; product_year=2018, period=0, resolution=1, field="an")

Returns `χ_3D`, `σ²_3D` of "regridded" WOA data using a nearest neighbor approach.
"""
function fit_to_grid(grid::OceanGrid, tracer; product_year=2018, period=0, resolution=1, field="an")
    ds = WOA_Dataset(tracer; product_year, period, resolution)
    field3D, lat, lon, depth = get_gridded_3D_field(ds, tracer, field)
    χ_3D, σ²_3D = mean_and_variance_gridded_3d_field(grid, field3D, lat, lon, depth)
    convert_to_SI_unit!(χ_3D, σ²_3D, ds, tracer, field)
    return χ_3D, σ²_3D
end

function raw_to_grid(grid::OceanGrid, tracer; product_year=2018, period=0, resolution=1, field="an")
    ds = WOA_Dataset(tracer; product_year, period, resolution)
    field3D, lat, lon, depth = get_gridded_3D_field(ds, tracer, field)
    χ_3D, σ²_3D, n_3D = raw_mean_and_variance_gridded_3d_field(grid, field3D, lat, lon, depth)
    convert_to_SI_unit!(χ_3D, σ²_3D, ds, tracer, field)
    return χ_3D, n_3D
end



#=========================================
observations function returns a DataFrames
=========================================#



function observations(ds::Dataset, tracer::String; metadatakeys=("lat", "lon", "depth"))
    var, v, ikeep = indices_and_var(ds, tracer)
    u = _unit(var)
    WOAmetadatakeys = varname.(metadatakeys)
    metadata = (metadatakeyvaluepair(ds[k], ikeep) for k in WOAmetadatakeys)
    df = DataFrame(metadata..., Symbol(tracer)=>float.(view(v, ikeep))*u)
    return df
end
"""
    observations(tracer::String; metadatakeys=("lat", "lon", "depth"))

Returns observations of `tracer` with its metadata.

### Example

```
obs = observations("po4")
```
"""
function observations(tracer::String; metadatakeys=("lat", "lon", "depth"), kwargs...)
    return Dataset(WOAfile(tracer; kwargs...), "r") do ds
        observations(ds, tracer; metadatakeys)
    end
end

function indices_and_var(ds::Dataset, tracer::String)
    var = ds[WOA_varname(tracer, "mn")]
    FV = _fillvalue(var)
    v = var.var[:][:,:,:,1]
    ikeep = findall(v .≠ FV)
    return var, v, ikeep
end
_unit(v) = convert_to_Unitful(get(v.attrib, "units", "nothing"))
_fillvalue(v) = get(v.attrib, "_FillValue", NaN)
metadatakeyvaluepair(v, idx) = @match name(v) begin
    "lon"   => (:lon => float.(v.var[:][[i.I[1] for i in idx]]))
    "lat"   => (:lat => float.(v.var[:][[i.I[2] for i in idx]]))
    "depth" => (:depth => float.(v.var[:][[i.I[3] for i in idx]]) * u"m")
end



#==================================
Helper functions
==================================#

function WOAfile(tracer; product_year=2018, period=0, resolution="1")
    println("Registering World Ocean Atlas data with DataDeps")
    @warn """You are about to use World Ocean Atlas data $(my_product_year(product_year)).

          Please cite the following corresponding reference(s):
          $(citation(tracer; product_year)))
          """
    register_WOA(tracer; product_year, period, resolution)
    return @datadep_str string(my_DataDeps_name(tracer; product_year, period, resolution),
                        "/",
                        WOA_NetCDF_filename(tracer; product_year, period, resolution))
end

function WOA_Dataset(tracer; product_year=2018, period=0, resolution=1)
    Dataset(WOAfile(tracer; product_year, period, resolution))
end

function remove_DataDep(tracer; product_year=2018, period=0, resolution=1)
    println("Removing WOA$(my_product_year(product_year)) $(my_averaging_period(period)) $(WOA_path_varname(tracer)) $(surface_grid_size(resolution)) data")
    nc_file = @datadep_str string(my_DataDeps_name(tracer; product_year, period, resolution), "/", WOA_NetCDF_filename(tracer; product_year, period, resolution))
    rm(nc_file; recursive=true, force=true)
end

