
WOA13_varname(vv, ff) = string(WOA13_filename_varname(vv), "_", ff)

function WOA13_interpolate(grd, vv, tt, gg, ff)
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

    itp = interpolate((woa_lat, woa_lon, woa_depth), woa_var_3d, Gridded(Linear()))
    return [itp(x, y, z) for x in grd["xt"], y in grd["yt"], z in grd["ztdepth"]
end



export WOA13_interpolate




"""

%%%----------------------------------------------------------------%%
%%%            Read the .nc file and build the WOA grid            %%
%%%----------------------------------------------------------------%%
% attributes of the variable
fprintf(['\n────── About to read and interpolate ' nc_file.var_name ': ──────\n'])
ncdisp(file_path,[vv '_' ff],'min') ;
fprintf('──────────────────────────────────────────────────────────\n')
fprintf(['\nReading NetCDF file from ' where '...'])
woa_xt = ncread(file_path,'lon') ;
woa_yt = ncread(file_path,'lat') ;
woa_zt = ncread(file_path,'depth') ;
woa_var_3d = ncread(file_path,[vv '_' ff]) ;
fprintf(' Done!\n')
% Reorder the variable index order (lat <-> lon from WOA to OCIM)
woa_var_3d = permute(woa_var_3d,[2 1 3]) ;
% Rearrange longitude range (WOA data is -180:180 and OCIM is 0:360)
[woa_xt, xt_reordering] = sort(mod(woa_xt,360)) ;
woa_var_3d(:,:,:) = woa_var_3d(:,xt_reordering,:) ;
% Mesh of WOA's grid
[woa_X,woa_Y,woa_Z] = meshgrid(woa_xt,woa_yt,woa_zt) ;

%%----------------------------------------------------------------%%
%%                 Interpolate to the OCIM grid                   %%
%%----------------------------------------------------------------%%
[ny,nx,nz] = size(M3d) ;
[woa_ny,woa_nx,woa_nz] = size(woa_var_3d) ;
fprintf('Inpainting the NaNs...')
for k = 1:woa_nz
  woa_var_3d(:,:,k) = inpaint_nans(woa_var_3d(:,:,k)) ;
end
fprintf(' Done.\nInterpolating in the vertical to the model grid...')
po4tmp = zeros(woa_ny,woa_nx,nz) ;
for i = 1:woa_ny
  for j = 1:woa_nx
    var_3d_tmp(i,j,:) = interp1(squeeze(woa_Z(1,1,:)),squeeze(woa_var_3d(i,j,:)),grid.zt) ;
  end
end
fprintf(' Done.\nInterpolating in the horizontal to the model grid...')
var_3d = 0 * M3d ;
for k = 1:nz
  var_3d(:,:,k) = interp2(woa_X(:,:,1),woa_Y(:,:,1),var_3d_tmp(:,:,k),grid.XT,grid.YT) ;
end
fprintf(' Done.\n')

%%----------------------------------------------------------------%%
%%                Save to appropriate directory                   %%
%%----------------------------------------------------------------%%
% I save the variable in column vector form
% as it uses less space and will be loaded and saved faster!
iocn = find(M3d) ;
var_ocn = var_3d(iocn) ; % no need to save the 3d field - less space
save_path = '../../results/data/' ;
save([save_path my.file_name],'var_ocn')
fprintf(['\nSaved as variable "var_ocn" in ' save_path my.file_name '\n'])

%%----------------------------------------------------------------%%
%%                         Delete raw data?                       %%
%%----------------------------------------------------------------%%
if ~use_OPeNDAP
  reply = input(['\n  Do you want to delete the local NetCDF file' nc_file.name '? y/n:\n    '],'s');
  switch reply
  case {'y','Y','yes','YES'}
    rm_command = ['rm ' file_path] ;
    system(rm_command) ;
    fprintf('  Deleting the NetCDF file.\n\n')
  case {'n','N','no','NO'}
    fprintf('  Keeping the NetCDF file.\n\n')
  otherwise
    fprintf('  I take that as a ''no''... Keeping the NetCDF file.\n\n')
  end
end
"""