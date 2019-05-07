

function WOA_surface_map(year, vv, tt, gg)
    println("Making a 2D array of surface WOA$(my_year(year)) $(my_averaging_period(tt)) $(WOA_path_varname(vv)) $(surface_grid_size(gg)) data")
    register_WOA(year, vv, tt, gg)
    nc_file = @datadep_str string(my_DataDeps_name(year, vv, tt, gg), "/", WOA_NetCDF_filename(year, vv, tt, gg))
    println("  Reading NetCDF file")
    woa_lon = ncread(nc_file, "lon")
    woa_lat = ncread(nc_file, "lat")
    woa_depth = ncread(nc_file, "depth")
    ff = "mn" # TODO figure out what to do "an" or "mn"
    woa_μ_2D = ncread(nc_file, WOA_varname(vv, ff))[:, :, 1, 1] # Annual mean of obs
    woa_μ_2D = permutedims(woa_μ_2D, [2 1])
    μfillvalue = ncgetatt(nc_file, WOA_varname(vv, ff), "_FillValue")
    woa_μ_2D[findall(woa_μ_2D .== μfillvalue)] .= NaN
    return woa_lat, woa_lon, woa_μ_2D
end

function WOA_remove(year, vv, tt, gg)
    println("Removing WOA$(my_year(year)) $(my_averaging_period(tt)) $(WOA_path_varname(vv)) $(surface_grid_size(gg)) data")
    nc_file = @datadep_str string(my_DataDeps_name(year, vv, tt, gg), "/", WOA_NetCDF_filename(year, vv, tt, gg))
    rm(nc_file; recursive=true, force=true)
end
