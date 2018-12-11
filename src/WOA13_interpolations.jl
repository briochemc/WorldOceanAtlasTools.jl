
WOA13_varname(vv, ff) = string(WOA13_filename_varname(vv), "_", my_field_type_code(ff))

function WOA13_interpolate_to_grid(grd, vv, tt, gg, ff)
    register_WOA13(vv, tt, gg)
    nc_file = @datadep_str string("WOA13/", WOA13_NetCDF_filename(vv, tt, gg))
    woa_lon = ncread(nc_file, "lon")
    woa_lat = ncread(nc_file, "lat")
    woa_depth = ncread(nc_file, "depth")
    woa_var_3d = ncread(nc_file, WOA13_varname(vv, ff))[:, :, :, 1] # could be "an" instead of "mn"
    # Reorder the variable index order (lat <-> lon from WOA to OCIM)
    woa_var_3d = permutedims(woa_var_3d, [2 1 3])
    # Rearrange longitude range (WOA data is -180:180 and OCIM is 0:360)
    woa_lon = sort(mod.(woa_lon, 360))
    lon_reordering = sortperm(mod.(woa_lon, 360))
    woa_var_3d .= woa_var_3d[:, lon_reordering, :]
    # Inpaint the NaNs
    fillvalue = ncgetatt(nc_file, WOA13_varname(vv, ff), "_FillValue")
    woa_var_3d[findall(woa_var_3d .== fillvalue)] .= NaN
    for z in eachindex(woa_depth)
        woa_var_3d[:,:,z] .= inpaint(woa_var_3d[:,:,z], cycledims=[2])
    end
    # Interpolate
    itp = interpolate((woa_lat, woa_lon, woa_depth), woa_var_3d, Gridded(Linear()))
    return [itp(y, x, z) for y in vec(grd["yt"]), x in vec(grd["xt"]), z in vec(grd["zt"])]
end

function WOA13_bin_to_grid(grd, vv, tt, gg, ff)
    println("Binning WOA 13 data into your grid and inpainting it")
    register_WOA13(vv, tt, gg)
    nc_file = @datadep_str string("WOA13/", WOA13_NetCDF_filename(vv, tt, gg))
    woa_lon = ncread(nc_file, "lon")
    woa_lat = ncread(nc_file, "lat")
    woa_depth = ncread(nc_file, "depth")
    woa_var_3d = ncread(nc_file, WOA13_varname(vv, ff))[:, :, :, 1] # could be "an" instead of "mn"
    # Reorder the variable index order (lat <-> lon from WOA to OCIM)
    woa_var_3d = permutedims(woa_var_3d, [2 1 3])
    # Rearrange longitude range (WOA data is -180:180 and OCIM is 0:360)
    woa_lon = mod.(woa_lon, 360)
    lon_reordering = sortperm(woa_lon)
    woa_lon = woa_lon[lon_reordering]
    woa_var_3d .= woa_var_3d[:, lon_reordering, :]
    # Find where there is data
    fillvalue = ncgetatt(nc_file, WOA13_varname(vv, ff), "_FillValue")
    CI = findall(woa_var_3d .≠ fillvalue) # Cartesian indices where there is data
    woa_var_col = woa_var_3d[CI]
    woa_lat_col = woa_lat[map(x -> x.I[1], CI)]
    woa_lon_col = woa_lon[map(x -> x.I[2], CI)]
    woa_depth_col = woa_depth[map(x -> x.I[3], CI)]
    # edges of `grd` grid for binning
    elat, elon, edepth = grid_edges(grd)
    # Bin the data into the `grd` grid and count
    var3d = zeros(length(grd["yt"]), length(grd["xt"]), length(grd["zt"]))
    count3d = copy(var3d)
    for i in eachindex(CI)
        @show i
        x = bin_index(woa_lon_col[i], elon)
        y = bin_index(woa_lat_col[i], elat)
        z = bin_index(woa_depth_col[i], edepth)
        var3d[y, x, z] += woa_var_col[i]
        count3d[y, x, z] += 1
    end
    # Average to get value
    @. var3d = var3d / count3d
    # inpaint the NaNs
    for z in eachindex(vec(grd["zt"]))
        var3d[:,:,z] .= inpaint(var3d[:,:,z], cycledims=[2])
    end

    return var3d
    # Inpaint the NaNs? Or use T?
end

function inpaint_using_T(var3d, wet3d, T)
    println("Warning: This inpainting currently has bugs!")
    iwet = findall(wet3d .== 1)
    var = var3d[iwet]
    K = findall(isnan.(var)) # indices of NaNs
    notK = findall(@. !isnan(var))
    W = Int64[] # indices of NaNs + neighbors
    for k in K
        W = push!(W, T[k, :].nzind...)
    end
    W = sort!(W)
    W = unique!(W)
    var[K] .= T[W, K] \ (T[W, notK] * -var[notK])
    return var
end

function inpaint_using_T_bis(var3d, wet3d, T)
    println("Warning: This inpainting currently has bugs!")
    iwet = findall(wet3d .== 1)
    var = var3d[iwet]
    K = findall(isnan.(var)) # indices of NaNs
    notK = findall(@. !isnan(var))
    var[K] .= T[K, K] \ (T[K, notK] * -var[notK])
    return var
end

lat_edges(grd) = vcat(vec(grd["yt"] .- 0.5grd["dyt"]), last(vec(grd["yt"] .+ 0.5grd["dyt"])))
lon_edges(grd) = vcat(vec(grd["xt"] .- 0.5grd["dxt"]), last(vec(grd["xt"] .+ 0.5grd["dxt"])))
depth_edges(grd) = vcat(0, cumsum(vec(grd["dzt"])))
grid_edges(grd) = lat_edges(grd), lon_edges(grd), depth_edges(grd)
bin_index(x, edges) = all(edges .≤ x) ? length(edges) - 1 : findfirst(edges .> x) - 1



export WOA13_interpolate, WOA13_varname, WOA13_bin_to_grid
