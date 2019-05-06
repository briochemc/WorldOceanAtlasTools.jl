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
    register_WOA(year, vv, tt, gg)

Registers a `datadep` for the variable `vv` averaged over `tt` at resolution `gg`.
"""
function register_WOA(year, vv, tt, gg)
    register(DataDep(
        my_DataDeps_name(year, vv, tt, gg),
        string(cite_WOD(year), "\n\n", cite_WOA(year, vv)),
        url_WOA(year, vv, tt, gg),
        sha2_256,
        fetch_method = fallback_download
    ))
    return nothing
end

#============================================================
DataDeps registering name
============================================================#
my_DataDeps_name(year, vv, tt, gg) = string(
    "WOA",
    my_year(year), "_",
    my_averaging_period(tt), "_",
    WOA_path_varname(vv), "_",
    surface_grid_size(gg)
)

#============================================================
WOA year of the data product
============================================================#
my_year(year) = @match year begin
    2005 || 05 || "2005" || "05" => "05"
    2009 || 09 || "2009" || "09" => "09"
    2013 || 13 || "2013" || "13" => "13"
    2018 || 18 || "2018" || "18" => "18"
    _ => error("Cannot register WOA data from year $year")
end

#============================================================
Variable names
============================================================#
incorrect_varname(vv) = """
"$vv" is an incorrect variable name.
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
WOA_path_varname(vv) = @match my_varname(vv) begin
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
WOA_filename_varname(vv) = @match my_varname(vv) begin
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
my_varname(vv) = @match vv begin
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
    _ => error(incorrect_varname(vv))
end

#============================================================
Averaging period
============================================================#
incorrect_averagingperiod(tt) = """
"$tt" is an incorrect averaging period.
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
my_averaging_period(tt) = @match tt begin
    0  || "00" ||  "0" ||    "annual" ||    "Annual" =>    "Annual"
    13 || "13" || "13" ||    "winter" ||    "Winter" =>    "Winter"
    14 || "14" || "14" ||    "spring" ||    "Spring" =>    "Spring"
    15 || "15" || "15" ||    "summer" ||    "Summer" =>    "Summer"
    16 || "16" || "16" ||    "autumn" ||    "Autumn" =>    "Autumn"
    1  || "01" ||  "1" ||   "january" ||   "January" =>   "January"
    2  || "02" ||  "2" ||  "february" ||  "February" =>  "February"
    3  || "03" ||  "3" ||     "march" ||     "March" =>     "March"
    4  || "04" ||  "4" ||     "april" ||     "April" =>     "April"
    5  || "05" ||  "5" ||       "may" ||       "May" =>       "May"
    6  || "06" ||  "6" ||      "june" ||      "June" =>      "June"
    7  || "07" ||  "7" ||      "july" ||      "July" =>      "July"
    8  || "08" ||  "8" ||    "august" ||    "August" =>    "August"
    9  || "09" ||  "9" || "september" || "September" => "September"
    10 || "10" || "10" ||   "october" ||   "October" =>   "October"
    11 || "11" || "11" ||  "november" ||  "November" =>  "November"
    12 || "12" || "12" ||  "december" ||  "December" =>  "December"
    _ => error(incorrect_averagingperiod(tt))
end
WOA_averaging_period(tt) = @match my_averaging_period(tt) begin
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

#============================================================
Field type
============================================================#
# ff currently unused.
# It is used when readong the ncfile though.
incorrect_field_type_code(ff) = """
"$ff" is an incorrect "field type code".
The "field type code" must be must be one of these:
    - "an" for the objectively analyzed climatology
    - "mn" for the statistical mean
    - "sd" for the standard deviation
You need to edit the `my_function` function to add more!
"""
my_field_type_code(ff) = @match lowercase(ff) begin
    "an" || "objectively analyzed climatology"  => "an"
    "mn" || "mean" || "statistical mean"        => "mn"
    "sd" || "std"  || "standard deviation"      => "sd"
    "dd" || "number of observations"            => "dd"
    _ => error(incorrect_varfunc(ff))
end

#============================================================
Resolution names
============================================================#
incorrect_resolution(gg) = """
"$gg" is an incorrect resolution.
Only these resolutions are available:
    - "1" for 1°×1° resolution
    - "5" for 5°×5° resolution
    - "0.25" for 0.25°×0.25° resolution
You need to edit the `myresolution` function to add more!
"""
WOA_path_resolution(gg) = @match my_resolution(gg) begin
    "0.25°" => "0.25"
    "1°"    => "1.00"
    "5°"    => "5deg"
end
WOA_filename_resolution(gg) = @match my_resolution(gg) begin
    "0.25°" => "04"
    "1°"    => "01"
    "5°"    => "5d"
end
surface_grid_size(gg) = @match my_resolution(gg) begin
    "0.25°" => "1440x720"
    "1°"    => "360x180"
    "5°"    => "73x36"
end
my_resolution(gg) = @match gg begin
    "0.25°×0.25°" || "04" || "0.25d" || "0.25" || "0.25°" => "0.25°"
       "1°×1°"    || "01" || "1d"    || "1"    || "1°"    => "1°"
       "5°×5°"    || "05" || "5d"    || "5"    || "5°"    => "5°"
    _ => error(incorrect_resolution(gg))
end

#============================================================
Decade names
============================================================#
WOA_decade(vv) = @match my_varname(vv) begin
    "Temp" || "Salt" || "Dens" || "Cond" => "decav"
    "O2" || "O2sat" || "AOU" || "DSi" || "DIP" || "DIN" => "all"
    _ => error(incorrect_varname(vv))
end

WOA_v2(vv) = @match my_varname(vv) begin
    "Salt" || "Temp" => "v2"
    "Dens" || "Cond" || "O2" || "O2sat" || "AOU" || "DSi" || "DIP" || "DIN" => ""
    _ => error(incorrect_varname(vv))
end

#============================================================
NetCDF file name
============================================================#
function WOA_NetCDF_filename(year, vv, tt, gg)
    return string("woa",
                  my_year(year), "_",
                  WOA_decade(vv), "_",
                  WOA_filename_varname(vv),
                  WOA_averaging_period(tt), "_",
                  WOA_filename_resolution(gg),
                  WOA_v2(vv), ".nc")
end

#============================================================
URL
============================================================#
"""
    url_WOA(year, vv, tt, gg)

Returns the URL (`String`) for the NetCDF file of the World Ocean Atlas.
This URL `String` typically looks like
    ```
    "https://data.nodc.noaa.gov/woa/WOA13/DATAv2/phosphate/netcdf/all/1.00/woa13_all_p00_01.nc"
    ```
"""
function url_WOA(year, vv, tt, gg)
    return string("https://data.nodc.noaa.gov/woa/WOA",
                  my_year(year), "/",
                  url_DATA(year), "/",
                  WOA_path_varname(vv), "/netcdf/",
                  WOA_decade(vv), "/",
                  WOA_path_resolution(gg), "/",
                  WOA_NetCDF_filename(year, vv, tt, gg))
end

url_DATA(year) = @match my_year(year) begin
    "09" => "DATA"
    "13" => "DATAv2"
    "18" => "DATA"
end

export WOA_NetCDF_filename, register_WOA, cite_WOA, WOA_filename_varname
