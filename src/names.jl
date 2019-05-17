# This file "resolves" the variable names used by the World Ocean Database (WOD).
# The idea is that the WOD has a naming convention (plus some exceptions)
# that are taken care of by the code below.

# Fallback for using direct download
function fallback_download(remotepath, localdir)
    @assert(isdir(localdir))
    filename = basename(remotepath)  # only works for URLs with filename as last part of name
    localpath = joinpath(localdir, filename)
    Base.download(remotepath, localpath)
    return localpath
end

"""
    register_WOA(product_year, tracer, period, resolution)

Registers a `datadep` for the variable `tracer` averaged over `period` at resolution `resolution`.
"""
function register_WOA(product_year, tracer, period, resolution)
    register(DataDep(
        my_DataDeps_name(product_year, tracer, period, resolution),
        string(citation(product_year, tracer)),
        url_WOA(product_year, tracer, period, resolution),
        sha2_256,
        fetch_method = fallback_download
    ))
    return nothing
end

#============================================================
DataDeps registering name
============================================================#
my_DataDeps_name(product_year, tracer, period, resolution) = string(
    "WOA",
    my_product_year(product_year), "_",
    my_averaging_period(period), "_",
    WOA_path_varname(tracer), "_",
    surface_grid_size(resolution)
)

#============================================================
WOA product_year of the data product
============================================================#
my_product_year(product_year) = @match product_year begin
    2005 || 05 || "2005" || "05" => "05"
    2009 || 09 || "2009" || "09" => "09"
    2013 || 13 || "2013" || "13" => "13"
    2018 || 18 || "2018" || "18" => "18"
    _ => error("Cannot register WOA data from year $product_year")
end

#============================================================
Variable names
============================================================#
incorrect_varname(tracer) = """
"$tracer" is an incorrect variable name.
Use one of these `String`s:
    - "t" for Temperature
    - "s" for Salinity
    - "I" for Density
    - "C" for Conductivity
    - "o" for Dissolved Oxygen
    - "O" for Percent Oxygen Saturation
    - "A" for Apparent Oxygen Utilization
    - "i" for Silicate
    - "p" for Phosphate
    - "n" for Nitrate
"""
WOA_path_varname(tracer) = @match my_varname(tracer) begin
    "Temp"  => "temperature"
    "Salt"  => "salinity"
    "Dens"  => "density"
    "O2"    => "oxygen"
    "O2sat" => "o2sat"
    "AOU"   => "AOU"
    "DSi"   => "silicate"
    "DIP"   => "phosphate"
    "DIN"   => "nitrate"
    "Cond"  => "conductivity"
end
WOA_filename_varname(tracer) = @match my_varname(tracer) begin
    "Temp"  => "t"
    "Salt"  => "s"
    "Dens"  => "I"
    "O2"    => "o"
    "O2sat" => "O"
    "AOU"   => "A"
    "DSi"   => "i"
    "DIP"   => "p"
    "DIN"   => "n"
    "Cond"  => "C"
end
my_varname(tracer) = @match tracer begin
    "t" || "T" || "Temperature" || "temperature" || "Temp" || "temp"                   => "Temp"
    "s" || "Salinity" || "salinity" || "Salt" || "salt"                                => "Salt"
    "I" || "Density" || "density" || "Dens" || "dens"                                  => "Dens"
    "o" || "O2" || "Oxygen" || "oxygen"  || "Dissolved oxygen"                         => "O2"
    "O" || "o2sat" || "O2sat" || "O2Sat" || "oxygen saturation" || "Oxygen saturation" => "O2sat"
    "A" || "AOU" || "Apparent oxygen utilization"                                      => "AOU"
    "i" || "silicate" || "DSi" || "Silicic Acid" || "Si(OH)4" || "SiOH4" || "sioh4"    => "DSi"
    "p" || "phosphate" || "PO4" || "Phosphate" || "DIP" || "po4"                       => "DIP"
    "n" || "nitrate" || "NO3" || "Nitrate" || "DIN" || "no3"                           => "DIN"
    "C" || "conductivity" || "Conductivity" || "Cond" || "cond"                        => "Cond"
    _ => error(incorrect_varname(tracer))
end
WOA_varname(tracer, field) = string(WOA_filename_varname(tracer), "_", my_field_type_code(field))

#============================================================
Averaging period
============================================================#
incorrect_averagingperiod(period) = """
"$period" is an incorrect averaging period.
The averaging period must fit the World Ocean Atlas naming convention.
That is, it must be one of these:
    - "00" for annual statistics, all data used
    - "13" to "16" for seasonal statistics:
        - "13" for winter (first three months of the year - Jan–Mar)
        - "14" for spring (Apr–Jun)
        - "15" for summer (Jul–Sep)
        - "16" for autumn (Oct–Dec)
    - "01" to "12" for monthly statistics (starting with "01" = January, to "12" = December)
"""
my_averaging_period(period::String) = @match lowercase(period) begin
    "00" ||  "0" ||    "annual"          =>    "Annual"
    "13" || "13" ||    "winter"          =>    "Winter"
    "14" || "14" ||    "spring"          =>    "Spring"
    "15" || "15" ||    "summer"          =>    "Summer"
    "16" || "16" ||    "autumn"          =>    "Autumn"
    "01" ||  "1" ||   "january" || "jan" =>   "January"
    "02" ||  "2" ||  "february" || "feb" =>  "February"
    "03" ||  "3" ||     "march" || "mar" =>     "March"
    "04" ||  "4" ||     "april" || "apr" =>     "April"
    "05" ||  "5" ||       "may" || "may" =>       "May"
    "06" ||  "6" ||      "june" || "jun" =>      "June"
    "07" ||  "7" ||      "july" || "jul" =>      "July"
    "08" ||  "8" ||    "august" || "aug" =>    "August"
    "09" ||  "9" || "september" || "sep" => "September"
    "10" || "10" ||   "october" || "oct" =>   "October"
    "11" || "11" ||  "november" || "nov" =>  "November"
    "12" || "12" ||  "december" || "dec" =>  "December"
    _ => error(incorrect_averagingperiod(period))
end
my_averaging_period(period::Int) = my_averaging_period(string(period))
WOA_averaging_period(period) = @match my_averaging_period(period) begin
    "Annual"    => "00"
    "Winter"    => "13"
    "Spring"    => "14"
    "Summer"    => "15"
    "Autumn"    => "16"
    "January"   => "01"
    "February"  => "02"
    "March"     => "03"
    "April"     => "04"
    "May"       => "05"
    "June"      => "06"
    "July"      => "07"
    "August"    => "08"
    "September" => "09"
    "October"   => "10"
    "November"  => "11"
    "December"  => "12"
end
seasonal_annual_monthly(period) = @match WOA_averaging_period(period) begin
    "00" => "annual"
    "13" || "14" || "15" || "16" => "seasonal"
    _ => "monthly"
end

#============================================================
Field type
============================================================#
incorrect_field_type_code(field) = """
"$field" is an incorrect "field type code".
The "field type code" must be must be one of these:
    - "an" for the objectively analyzed climatology
    - "mn" for the statistical mean
    - "sd" for the standard deviation
You need to edit the `my_function` function to add more!
"""
my_field_type_code(field) = @match lowercase(field) begin
    "an" || "objectively analyzed climatology"  => "an"
    "mn" || "mean" || "statistical mean"        => "mn"
    "sd" || "std"  || "standard deviation"      => "sd"
    "dd" || "number of observations"            => "dd"
    _ => error(incorrect_varfunc(field))
end

#============================================================
Resolution names
============================================================#
incorrect_resolution(resolution) = """
"$resolution" is an incorrect resolution.
Only these resolutions are available:
    - "1" for 1°×1° resolution
    - "5" for 5°×5° resolution
    - "0.25" for 0.25°×0.25° resolution
You need to edit the `myresolution` function to add more!
"""
WOA_path_resolution(resolution) = @match my_resolution(resolution) begin
    "0.25°" => "0.25"
    "1°"    => "1.00"
    "5°"    => "5deg"
end
WOA_filename_resolution(resolution) = @match my_resolution(resolution) begin
    "0.25°" => "04"
    "1°"    => "01"
    "5°"    => "5d"
end
surface_grid_size(resolution) = @match my_resolution(resolution) begin
    "0.25°" => "1440x720"
    "1°"    => "360x180"
    "5°"    => "73x36"
end
my_resolution(resolution) = @match resolution begin
    "0.25°×0.25°" || "04" || "0.25d" || "0.25" || "0.25°" => "0.25°"
       "1°×1°"    || "01" || "1d"    || "1"    || "1°"    => "1°"
       "5°×5°"    || "05" || "5d"    || "5"    || "5°"    => "5°"
    _ => error(incorrect_resolution(resolution))
end
WOA09_file_resolution(resolution) = @match my_resolution(resolution) begin
    "1°" => "1deg"
    "5°" => "5deg"
    _ => error("No such resolution for WOA09 data")
end

#============================================================
Decade names
============================================================#
WOA_decade(tracer) = @match my_varname(tracer) begin
    "Temp" || "Salt" || "Dens" || "Cond" => "decav"
    "O2" || "O2sat" || "AOU" || "DSi" || "DIP" || "DIN" => "all"
    _ => error(incorrect_varname(tracer))
end

WOA_v2(tracer) = @match my_varname(tracer) begin
    "Salt" || "Temp" => "v2"
    "Dens" || "Cond" || "O2" || "O2sat" || "AOU" || "DSi" || "DIP" || "DIN" => ""
    _ => error(incorrect_varname(tracer))
end

#============================================================
NetCDF file name
============================================================#
function WOA_NetCDF_filename(product_year, tracer, period, resolution)
    return string("woa",
                  my_product_year(product_year), "_",
                  WOA_decade(tracer), "_",
                  WOA_filename_varname(tracer),
                  WOA_averaging_period(period), "_",
                  WOA_filename_resolution(resolution),
                  WOA_v2(tracer), ".nc")
end

#============================================================
URLs
============================================================#
"""
    url_WOA(product_year, tracer, period, resolution)

Returns the URL (`String`) for the NetCDF file of the World Ocean Atlas.
This URL `String` typically looks like
    ```
    "https://data.nodc.noaa.gov/woa/WOA13/DATAv2/phosphate/netcdf/all/1.00/woa13_all_p00_01.nc"
    ```
"""
url_WOA(product_year, tracer, period, resolution) = string("https://data.nodc.noaa.gov/woa/WOA",
                                   my_product_year(product_year), "/",
                                   url_DATA(product_year), "/",
                                   WOA_path_varname(tracer), "/netcdf/",
                                   WOA_decade(tracer), "/",
                                   WOA_path_resolution(resolution), "/",
                                   WOA_NetCDF_filename(product_year, tracer, period, resolution))
url_WOA_THREDDS_18(tracer, period, resolution) = string("https://data.nodc.noaa.gov/thredds/dodsC/ncei/woa/",
                                        WOA_path_varname(tracer), "/",
                                        WOA_decade(tracer), "/",
                                        WOA_path_resolution(resolution), "/",
                                        WOA_NetCDF_filename(2018, tracer, period, resolution))
url_WOA_THREDDS_09(tracer, period, resolution) = string("https://data.nodc.noaa.gov/thredds/dodsC/woa09/",
                                        WOA_path_varname(tracer), "_",
                                        seasonal_annual_monthly(period), "_",
                                        WOA09_file_resolution(resolution), ".nc")
url_WOA_THREDDS(product_year, tracer, period, resolution) = @match my_product_year(product_year) begin
    "18" => url_WOA_THREDDS_18(tracer, period, resolution)
    "09" => url_WOA_THREDDS_09(tracer, period, resolution)
    _ => "No THREDDS links for year $product_year"
end
url_DATA(product_year) = @match my_product_year(product_year) begin
    "09" => "DATA"
    "13" => "DATAv2"
    "18" => "DATA"
end

