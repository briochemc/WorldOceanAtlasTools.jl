DataDep("WOA13",
    WOA13_citations(),
    WOA13_url(vv, ),
    sha2_256
);

function WOA13_citations()
    """
    Citation for WOA13

    - World Ocean Database:
        Boyer, T. P., J. I. Antonov, O. K. Baranova, C. Coleman, H. E. Garcia, A. Grodsky, D. R. Johnson, R. A. Locarnini, A. V. Mishonov, T. D. O'Brien, C. R. Paver, J. R. Reagan, D. Seidov, I. V. Smolyar, and M. M. Zweng, 2013: World Ocean Database 2013, NOAA Atlas NESDIS 72, S. Levitus, Ed., A. Mishonov, Technical Ed.; Silver Spring, MD, 209 pp., doi:10.7289/V5NZ85MT

    - Temperature:
        Locarnini, R. A., A. V. Mishonov, J. I. Antonov, T. P. Boyer, H. E. Garcia, O. K. Baranova, M. M. Zweng, C. R. Paver, J. R. Reagan, D. R. Johnson, M. Hamilton, and D. Seidov, 2013. World Ocean Atlas 2013, Volume 1: Temperature. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 73, 40 pp.

    - Salinity:
        Zweng, M. M., J. R. Reagan, J. I. Antonov, R. A. Locarnini, A. V. Mishonov, T. P. Boyer, H. E. Garcia, O. K. Baranova, D. R. Johnson, D. Seidov, M. M. Biddle, 2013. World Ocean Atlas 2013, Volume 2: Salinity. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 74, 39 pp.

    - Oxygen:
        Garcia, H. E., R. A. Locarnini, T. P. Boyer, J. I. Antonov, O. K. Baranova, M. M. Zweng, J. R. Reagan, D. R. Johnson, 2014. World Ocean Atlas 2013, Volume 3: Dissolved Oxygen, Apparent Oxygen Utilization, and Oxygen Saturation. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 75, 27 pp.

    - Nutrients:
        Garcia, H. E., R. A. Locarnini, T. P. Boyer, J. I. Antonov, O. K. Baranova, M. M. Zweng, J. R. Reagan, D. R. Johnson, 2014. World Ocean Atlas 2013, Volume 4: Dissolved Inorganic Nutrients (phosphate, nitrate, silicate). S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 76, 25 pp.
    """
end

# variable name
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

WOA13_path_varname(vv) = @match my_varname(vv) begin
    "Temp" => "temperature"
    "Salt" => "salinity"
    "Dens" => "density"
    "O2" => "oxygen"
    "O2sat" => "o2sat"
    "AOU" => "AOU"
    "DSi" => "silicate"
    "DIP" => "phosphate"
    "DIN" => "nitrate"
    "Cond" => "conductivity"
end
WOA13_filename_varname(vv) = @match my_varname(vv) begin
    "Temp" => "t"
    "Salt" => "s"
    "Dens" => "I"
    "O2" => "o"
    "O2sat" => "O"
    "AOU" => "A"
    "DSi" => "i"
    "DIP" => "p"
    "DIN" => "n"
    "Cond" => "C"
end
my_varname(vv) = @match vv begin
    "t", "T", "Temperature", "temperature", "Temp", "temp"                    => "Temp"
    "s", "Salinity", "salinity", "Salt", "salt"                               => "Salt"
    "I", "Density", "density", "Dens", "dens"                                 => "Dens"
    "o", "O2", "Oxygen", "oxygen" , "Dissolved oxygen"                        => "O2"
    "O", "o2sat", "O2sat", "O2Sat", "oxygen saturation", "Oxygen saturation"  => "O2sat"
    "A", "AOU", "Apparent oxygen utilization"                                 => "AOU"
    "i", "silicate", "DSi", "Silicic Acid", "Si(OH)4", "SiOH4"                => "DSi"
    "p", "phosphate", "PO4", "Phosphate", "DIP"                               => "DIP"
    "n", "nitrate", "NO3", "Nitrate", "DIN"                                   => "DIN"
    "C", "conductivity", "Conductivity", "Cond", "cond"                       => "Cond"
    _ => error(incorrect_varname(vv))
end

# Averaging period
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

my_averaging_period(tt) = @match tt begin
    0,  "00",   "annual",   "Annual" =>    "Annual"
    13, "13",   "winter",   "Winter" =>    "Winter"
    14, "14",   "spring",   "Spring" =>    "Spring"
    15, "15",   "summer",   "Summer" =>    "Summer"
    16, "16",   "autumn",   "Autumn" =>    "Autumn"
    1,  "01",  "january",  "January" =>   "January"
    2,  "02", "february", "February" =>  "February"
    3,  "03",    "march",    "March" =>     "March"
    4,  "04",    "april",    "April" =>     "April"
    5,  "05",      "may",      "May" =>      "May"
    6,  "06",     "june",     "June" =>      "June"
    7,  "07",     "july",     "July" =>      "July"
    8,  "08",   "august",   "August" =>    "August"
    9,  "09","september","September" => "September"
    10, "10",  "october",  "October" =>   "October"
    11, "11", "november", "November" =>  "November"
    12, "12", "december", "December" =>  "December"
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
WOA13_path_resolution(gg) = @match my_resolution(gg) begin
    "0.25°" => "0.25"
    "1°"    => "1.00"
    "5°"    => "5deg"
end
WOA13_filename_resolution(gg) = @match my_resolution(gg) begin
    "0.25°" => "04"
    "1°"    => "01"
    "5°"    => "5d"
end
my_resolution(gg) = @match gg begin
     "0.25°×0.25°", "04", "0.25", "0.25d", "0.25°" => "0.25°"
     "1°×1°", "01", "1d", "1°"                     => "1°"
     "5°×5°", "05", "5d", "5°"                     => "5°"
    _ => error(incorrect_resolution(gg))
end

WOA13_decade(vv) = @match vv begin
    "t" || "s" || "I" || "C" => "decav"
    "o" || "O" || "A" || "i" || "p" || "n" => "all"
    _ => error(incorrect_varname(vv))
end

function WOA13_NetCDF_filename(vv, gg, tt)
    return string("woa13_", WOA13_decade(vv), "_",
                  vv, tt, "_",
                  WOA13_filename_resolution(gg), ".nc")
end

"""
    WOA13_URL(vv, tt, ff, gg)

Returns the URL (`String`) for the NetCDF file of the World Ocean Atlas.
This URL `String` typically looks like
```
https://data.nodc.noaa.gov/woa/WOA13/DATAv2/phosphate/netcdf/all/1.00/woa13_all_p00_01.nc
```
"""
function WOA13_URL(vv, tt, ff, gg)
    return string("https://data.nodc.noaa.gov/woa/WOA13/DATAv2/",
                  WOA13_path_varname(vv), "/netcdf/",
                  WOA13_decade(vv), "/",
                  WOA13_path_resolution(gg), "/",
                  WOA13_NetCDF_filename(vv, gg, tt))
end


