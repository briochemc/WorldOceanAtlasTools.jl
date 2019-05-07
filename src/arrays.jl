

function WOA_surface_map(year, vv, tt, gg, ff)
    println("Making a 2D array of surface WOA$(my_year(year)) $(my_averaging_period(tt)) $(WOA_path_varname(vv)) $(surface_grid_size(gg)) data")
    ds = Dataset(NetCDF_path(year, vv, tt, gg))
    map2D = ds[WOA_varname(vv, ff)][:][:, :, 1, 1] # 
    map2D = permutedims(map2D, [2 1])
    return map2D
end


function NetCDF_path(year, vv, tt, gg, verbose=false)
    print("OPeNDAP")
    verbose && print(": ", url_WOA_THREDDS(year, vv, tt, gg))
    return try # OPeNDAP
        Dataset(url_WOA_THREDDS(year, vv, tt, gg))
        println(" ✅")
        url_WOA_THREDDS(year, vv, tt, gg)
    catch
        println(" ❎")
        register_WOA(year, vv, tt, gg)
        @datadep_str string(my_DataDeps_name(year, vv, tt, gg), "/", WOA_NetCDF_filename(year, vv, tt, gg))
    end
end

function WOA_remove(year, vv, tt, gg)
    println("Removing WOA$(my_year(year)) $(my_averaging_period(tt)) $(WOA_path_varname(vv)) $(surface_grid_size(gg)) data")
    nc_file = @datadep_str string(my_DataDeps_name(year, vv, tt, gg), "/", WOA_NetCDF_filename(year, vv, tt, gg))
    rm(nc_file; recursive=true, force=true)
end

