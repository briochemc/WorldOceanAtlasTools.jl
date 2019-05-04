

function WOA13_surface_map(vv, tt, gg)
    println("Making a 2D array of surface WOA 13 data")
    register_WOA13(vv, tt, gg)
    nc_file = @datadep_str string("WOA13_", my_varname(vv), "/", WOA13_NetCDF_filename(vv, tt, gg))
    println("  Reading NetCDF file")
    woa_lon = ncread(nc_file, "lon")
    woa_lat = ncread(nc_file, "lat")
    woa_depth = ncread(nc_file, "depth")
    ff = "an"
    woa_μ_2D = ncread(nc_file, WOA13_varname(vv, ff))[:, :, 1, 1] # Annual mean of obs
    woa_μ_2D = permutedims(woa_μ_2D, [2 1])
    μfillvalue = ncgetatt(nc_file, WOA13_varname(vv, ff), "_FillValue")
    woa_μ_2D[findall(woa_μ_2D .== μfillvalue)] .= NaN
    return woa_lat, woa_lon, woa_μ_2D
end
