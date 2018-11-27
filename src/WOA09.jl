#DataDep("WOA13",
#    """
#    Dataset: Phosphate concentrations from the World Ocean Atlas Database 2013.
#
#    Citations:
#    World Ocean Database:
#    Boyer, T.P., J. I. Antonov, O. K. Baranova, C. Coleman, H. E. Garcia, A. Grodsky, D. R. Johnson, R. A. Locarnini, A. V. Mishonov, T.D. O'Brien, C.R. Paver, J.R. Reagan, D. Seidov, I. V. Smolyar, and M. M. Zweng, 2013: World Ocean Database 2013, NOAA Atlas NESDIS 72, S. Levitus, Ed., A. Mishonov, Technical Ed.; Silver Spring, MD, 209 pp., http://doi.org/10.7289/V5NZ85MT
#
#    Nutrients:
#    Garcia, H. E., R. A. Locarnini, T. P. Boyer, J. I. Antonov, O.K. Baranova, M.M. Zweng, J.R. Reagan, D.R. Johnson, 2014. World Ocean Atlas 2013, Volume 4: Dissolved Inorganic Nutrients (phosphate, nitrate, silicate). S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 76, 25 pp.
#    """,
#    "????", # DOES NOT WORK?
#    sha2_256
#);



register(DataDep("WOA09",
    """
    Dataset: World Ocean Atlas Database 2009.

    Citations:
    World Ocean Database:
    T. P. Boyer, J. I. Antonov , O. K. Baranova, H. E. Garcia, D. R. Johnson, R. A. Locarnini, A. V. Mishonov, T. D. O’Brien, D. Seidov, I. V. Smolyar, M. M. Zweng, 2009. World Ocean Database 2009. S. Levitus, Ed., NOAA Atlas NESDIS 66, U.S. Gov. Printing Office, Wash., D.C., 216 pp., DVDs.

    Temperature:
    Locarnini, R. A., A. V. Mishonov, J. I. Antonov, T. P. Boyer, H. E. Garcia, O. K. Baranova, M. M. Zweng, and D. R. Johnson, 2010. World Ocean Atlas 2009, Volume 1: Temperature. S. Levitus, Ed. NOAA Atlas NESDIS 68, U.S. Government Printing Office, Washington, D.C., 184 pp.

    Oxygen:
    Garcia, H. E., R. A. Locarnini, T. P. Boyer, J. I. Antonov, O. K. Baranova, M. M. Zweng, and D. R. Johnson, 2010. World Ocean Atlas 2009, Volume 3: Dissolved Oxygen, Apparent Oxygen Utilization, and Oxygen Saturation. S. Levitus, Ed. NOAA Atlas NESDIS 70, U.S. Government Printing Office, Washington, D.C., 344 pp.

    Salinity:
    Antonov, J. I., D. Seidov, T. P. Boyer, R. A. Locarnini, A. V. Mishonov, H. E. Garcia, O. K. Baranova, M. M. Zweng, and D. R. Johnson, 2010. World Ocean Atlas 2009, Volume 2: Salinity. S. Levitus, Ed. NOAA Atlas NESDIS 69, U.S. Government Printing Office, Washington, D.C., 184 pp.

    Nutrients:
    Garcia, H. E., R. A. Locarnini, T. P. Boyer, J. I. Antonov, M. M. Zweng, O. K. Baranova, and D. R. Johnson, 2010. World Ocean Atlas 2009, Volume 4: Nutrients (phosphate, nitrate, silicate). S. Levitus, Ed. NOAA Atlas NESDIS 71, U.S. Government Printing Office, Washington, D.C., 398 pp.
    """,
    "https://data.nodc.noaa.gov/thredds/fileServer/woa/woa09/NetCDFdata/phosphate_annual_5deg.nc",
    sha2_256
));

variables = ("Temperature", "Salinity", "Dissolved Oxygen", "Oxygen Saturation", "Apparent Oxygen
       Utilization", "Phosphate", "Silicate", "Nitrate")

# """
# Usage:
#
# # using NetCDF
#
# ncinfo(datadep"WOA09/phosphate_annual_5deg.nc")
# """

register()



WOA_year(yy) = @match yy begin
    "09" => "WOA09"
    _    => error("No other year than 09 for now.")
end


incorrect_varname(vv) = """
"$vv" is an incorrect variable name.
The variable name must fit the World Ocean Atlas naming convention.
That is, it must be one of these `String`s:
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

WOA_varname(vv) = @match vv begin
    "t" => "temperature"
    "s" => "salinity"
    "I" => "density"
    "C" => "conductivity"
    "o" => "oxygen"
    "O" => "o2sat"
    "A" => "AOU"
    "i" => "silicate"
    "p" => "phosphate"
    "n" => "nitrate"
    _ => error(incorrect_varname(vv))
end

WOA09_varname(vv) = @match vv begin
    "t" => "temperature"
    "s" => "salinity"
    "I" => "density"
    "o" => "dissolved_oxygen"
    "O" => "oxygen_saturation"
    "A" => "apparent_oxygen_utilization"
    "i" => "silicate"
    "p" => "phosphate"
    "n" => "nitrate"
    _ => error(incorrect_varname(vv))
end

WOA13_varname(vv) = @match vv begin
    "t" => "temperature"
    "s" => "salinity"
    "I" => "density"
    "o" => "dissolved_oxygen"
    "O" => "oxygen_saturation"
    "A" => "A"
    "i" => "silicate"
    "p" => "phosphate"
    "n" => "nitrate"
    _ => error(incorrect_varname(vv))
end

my_varname(vv) = @match vv begin
    "t" => "Temp"
    "s" => "Salt"
    "I" => "Dens"
    "C" => "Cond"
    "o" => "O2"
    "O" => "O2sat"
    "A" => "AOU"
    "i" => "DSi"
    "p" => "DIP"
    "n" => "DIN"
    _ => error(incorrect_varname(vv))
end

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

WOA_averagingperiodtype(tt) = @match parse(Int,tt) begin
    0     => "annual"
    13:16 => "seasonal"
    1:12  => "monthly"
    _ => error(incorrect_averagingperiod(tt))
end

incorrect_varfunc(ff) = """
"$ff" is an incorrect "field type code".
The "field type code" must be must be one of these:
    - "an" for the statistical mean
    - "sd" for the the standard deviation
You need to edit the `my_function` function to add more!
"""

my_function(ff) = @match ff begin
    "an" => "mean"
    "sd" => "STD"
    _ => error(incorrect_varfunc(ff))
end

incorrect_resolution(gg) = """
"$gg" is an incorrect resolution.
Only these resolutions are available:
    - "01" for 1°×1° resolution
You need to edit the `myresolution` function to add more!
"""

my_resolution(gg) = @match gg begin
    "01" => "WOA1x1"
    _ => error(incorrect_resolution(gg))
end

WOA_resolution(gg) = @match gg begin
    "01" => "1.00"
    _ => error(incorrect_resolution(gg))
end

WOA_decade(vv) = @match vv begin
    "t" || "s" || "I" || "C" => "decav"
    "o" || "O" || "A" || "i" || "p" || "n" => "all"
    _ => error(incorrect_varname(vv))
end

WOA_NetCDF_filename(vv, gg, tt, yy) = string("woa", yy, "_", WOA_decade(vv), "_", vv, tt, "_", gg, ".nc")
WOA09_NetCDF_filename(vv, gg, tt) = string("WOA09/NetCDFdata", "_", WOA_decade(vv), "_", vv, tt, "_", gg, ".nc")

WOA09_NetCDF_filemame() = "https://data.nodc.noaa.gov/woa/WOA09/NetCDFdata/"

https://data.nodc.noaa.gov/woa/WOA09/NetCDFdata/apparent_oxygen_utilization_annual_1deg.nc
https://data.nodc.noaa.gov/woa/WOA13/DATAv2/phosphate/netcdf/all/1.00/woa13_all_p00_01.nc

function WOA_NetCDF_URL(vv, tt, ff, gg, yy)
    return string("https://data.nodc.noaa.gov/woa/",
                  WOA_year(yy), "/" ,WOA_varname(vv), "/netcdf/",
                  WOA_decade(vv), "/", WOA_resolution(gg), "/", WOA_NetCDF_filename(vv, gg, tt, yy))
end
