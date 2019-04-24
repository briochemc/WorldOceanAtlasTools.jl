
WOA13_varname(vv, ff) = string(WOA13_filename_varname(vv), "_", my_field_type_code(ff))

"""
    WOA13_mean_and_variance_per_grid_box(grd, vv, tt, gg)

Bin the data into the grid, `grd`
That is take the observations `μᵢ` from WOA's grid (with `gg` resolution)
that are in a given grid box of `grd`,
and take:
- the mean of those observations for `μ`
- the variance of those observtations for `σ²`.
(Note the standard deviation provided by the WOA is used because not reliable IMO.)
of the average of the Xᵢ (in that box).
Hence if there are `n` observations `μᵢ` in a given `grd` box, the output
for that given box is:
- μ = Σᵢ μᵢ / n
- σ² = ∑ᵢ μᵢ² / n - μ²
"""
function WOA13_mean_and_variance_per_grid_box(grd, vv, tt, gg)
    println("Averaging WOA 13 data into your grid")
    register_WOA13(vv, tt, gg)
    nc_file = @datadep_str string("WOA13/", WOA13_NetCDF_filename(vv, tt, gg))
    println("  Reading NetCDF file")
    woa_lon = ncread(nc_file, "lon")
    woa_lat = ncread(nc_file, "lat")
    woa_depth = ncread(nc_file, "depth")
    ff = "an"
    woa_μ_3d = ncread(nc_file, WOA13_varname(vv, ff))[:, :, :, 1] # Annual mean of obs
    # Reorder the variable index order (lat <-> lon from WOA to OCIM)
    println("  Rearranging data")
    woa_μ_3d = permutedims(woa_μ_3d, [2 1 3])
    # Rearrange longitude range (WOA data is -180:180 and OCIM is 0:360)
    woa_lon = mod.(woa_lon, 360)
    lon_reordering = sortperm(woa_lon)
    woa_lon = woa_lon[lon_reordering]
    woa_μ_3d .= woa_μ_3d[:, lon_reordering, :]
    # Find where there is data for both mean and std
    println("  Filtering data")
    μfillvalue = ncgetatt(nc_file, WOA13_varname(vv, ff), "_FillValue")
    CI = findall((woa_μ_3d .≠ μfillvalue) .& (woa_μ_3d .≠ 0)) # filter out fill-values and 0's
    woa_μ_col = woa_μ_3d[CI]
    woa_lat_col = woa_lat[map(x -> x.I[1], CI)]
    woa_lon_col = woa_lon[map(x -> x.I[2], CI)]
    woa_depth_col = woa_depth[map(x -> x.I[3], CI)]
    # edges of `grd` grid for binning
    elat, elon, edepth = grid_edges(grd)
    # std is very small (but not zero) where there is no obs,
    # so that (x - μ)² / σ² = 0 in these boxes
    println("  Averaging data over each grid box")
    μ_3d = zeros(length(grd["yt"]), length(grd["xt"]), length(grd["zt"]))
    σ²_3d = zeros(length(grd["yt"]), length(grd["xt"]), length(grd["zt"]))
    n_woa_3d = zeros(length(grd["yt"]), length(grd["xt"]), length(grd["zt"]))
    for i in eachindex(CI)
        x = bin_index(woa_lon_col[i], elon)
        y = bin_index(woa_lat_col[i], elat)
        z = bin_index(woa_depth_col[i], edepth)
        μ_3d[y, x, z] += woa_μ_col[i]      # μ = Σᵢ μᵢ / n
        σ²_3d[y, x, z] += woa_μ_col[i]^2   # σ² = Σᵢ μᵢ² / n - μ²
        n_woa_3d[y, x, z] += 1
    end
    μ_3d .= μ_3d ./ n_woa_3d               # μ = Σᵢ μᵢ / n
    σ²_3d .= σ²_3d ./ n_woa_3d .- μ_3d.^2  # σ² = Σᵢ μᵢ² / n - μ²
    # Enforce μ = 0 and σ = ∞ where no observations
    # (Instead of NaNs)
    println("  Setting μ = 0 and σ² = ∞ where no obs")
    μ_3d[findall(n_woa_3d .== 0)] .= 0.0
    σ²_3d[findall(n_woa_3d .== 0)] .= Inf
    println("  Setting a realistic minimum for σ²")
    μ = mean(μ_3d, weights(n_woa_3d))
    σ²_3d .= max.(σ²_3d, 1e-4μ^2)
    # Convert to SI units
    μ_WOAunit = ncgetatt(nc_file, WOA13_varname(vv, ff), "units")
    μ_unit = convert_WOAunits_to_unitful(μ_WOAunit)
    μ_3d .*= ustrip(upreferred(1.0μ_unit))
    σ²_3d .*= ustrip(upreferred(1.0μ_unit^2))
    return μ_3d, σ²_3d
end

#==================================
    Helper functions
==================================#

lat_edges(grd) = vcat(vec(grd["yt"] .- 0.5grd["dyt"]), last(vec(grd["yt"] .+ 0.5grd["dyt"])))
lon_edges(grd) = vcat(vec(grd["xt"] .- 0.5grd["dxt"]), last(vec(grd["xt"] .+ 0.5grd["dxt"])))
depth_edges(grd) = vcat(0, cumsum(vec(grd["dzt"])))
grid_edges(grd) = lat_edges(grd), lon_edges(grd), depth_edges(grd)

# `bin_index` is called so many times on the same indices that much faster memoized :)
@memoize bin_index(x, edges) = all(edges .≤ x) ? length(edges) - 1 : findfirst(edges .> x) - 1

export WOA13_mean_and_variance_per_grid_box, WOA13_varname
