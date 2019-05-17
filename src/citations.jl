citation(year, vv) = @match my_varname(vv) begin
    "DSi" || "DIP" || "DIN" => citation_Nutrients(year)
    "Temp" => citation_Temperature(year)
    "Salt" => citation_Salinity(year)
    "O2" || "O2sat" || "AOU" => citation_Oxygen(year)
    "Dens" || "Cond" => citation(year)
    _ => error("Not sure what you are trying to cite.")
end

citation(year) = @match my_product_year(year) begin
    "13" => "Boyer, T. P., J. I. Antonov, O. K. Baranova, C. Coleman, H. E. Garcia, A. Grodsky, D. R. Johnson, R. A. Locarnini, A. V. Mishonov, T. D. O'Brien, C. R. Paver, J. R. Reagan, D. Seidov, I. V. Smolyar, and M. M. Zweng, 2013: World Ocean Database 2013, NOAA Atlas NESDIS 72, S. Levitus, Ed., A. Mishonov, Technical Ed.; Silver Spring, MD, 209 pp., doi:10.7289/V5NZ85MT"
    "18" => "Boyer, T. P., O. K. Baranova, C. Coleman, H. E. Garcia, A. Grodsky, R. A. Locarnini, A. V. Mishonov, C. R. Paver, J. R. Reagan, D. Seidov, I. V. Smolyar, K. Weathers, M. M. Zweng,(2018): World Ocean Database 2018. A. V. Mishonov, Technical Editor, NOAA Atlas NESDIS 87."
    _ => "I could not find a citation for WOD$(my_product_year(year)). Add it if you know where to find it!"
end

citation_Temperature(year) = @match my_product_year(year) begin
    "09" => "Locarnini, R. A., A. V. Mishonov, J. I. Antonov, T. P. Boyer, H. E. Garcia, O. K. Baranova, M. M. Zweng, and D. R. Johnson, 2010. World Ocean Atlas 2009, Volume 1: Temperature. S. Levitus, Ed. NOAA Atlas NESDIS 68, U.S. Government Printing Office, Washington, D.C., 184 pp."
    "13" => "Locarnini, R. A., A. V. Mishonov, J. I. Antonov, T. P. Boyer, H. E. Garcia, O. K. Baranova, M. M. Zweng, C. R. Paver, J. R. Reagan, D. R. Johnson, M. Hamilton, and D. Seidov, 2013. World Ocean Atlas 2013, Volume 1: Temperature. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 73, 40 pp."
    "18" => "Locarnini, R. A., A. V. Mishonov, O. K. Baranova, T. P. Boyer, M. M. Zweng, H. E. Garcia, J. R. Reagan, D. Seidov, K. Weathers, C. R. Paver, and I. Smolyar, 2018. World Ocean Atlas 2018, Volume 1: Temperature. A. Mishonov Technical Ed.; in preparation."
    _ => error("No citation for WOA$(my_product_year(year)) Temperature. Add it if it should be there!")
end

citation_Salinity(year) = @match my_product_year(year) begin
    "09" => "Antonov, J. I., D. Seidov, T. P. Boyer, R. A. Locarnini, A. V. Mishonov, H. E. Garcia, O. K. Baranova, M. M. Zweng, and D. R. Johnson, 2010. World Ocean Atlas 2009, Volume 2: Salinity. S. Levitus, Ed. NOAA Atlas NESDIS 69, U.S. Government Printing Office, Washington, D.C., 184 pp."
    "13" => "Zweng, M. M., J. R. Reagan, J. I. Antonov, R. A. Locarnini, A. V. Mishonov, T. P. Boyer, H. E. Garcia, O. K. Baranova, D. R. Johnson, D. Seidov, M. M. Biddle, 2013. World Ocean Atlas 2013, Volume 2: Salinity. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 74, 39 pp."
    "18" => "Zweng, M. M., J. R. Reagan, D. Seidov, T. P. Boyer, R. A. Locarnini, H. E. Garcia, A. V. Mishonov, O. K. Baranova, K. Weathers, C. R. Paver, and I. Smolyar, 2018. World Ocean Atlas 2018, Volume 2: Salinity. A. Mishonov Technical Ed.; in preparation."
    _ => error("No citation for WOA$(my_product_year(year)) Salinity. Add it if it should be there!")
end

citation_Oxygen(year) = @match my_product_year(year) begin
    "09" => "Garcia, H. E., R. A. Locarnini, T. P. Boyer, J. I. Antonov, O. K. Baranova, M. M. Zweng, and D. R. Johnson, 2010. World Ocean Atlas 2009, Volume 3: Dissolved Oxygen, Apparent Oxygen Utilization, and Oxygen Saturation. S. Levitus, Ed. NOAA Atlas NESDIS 70, U.S. Government Printing Office, Washington, D.C., 344 pp."
    "13" => "Garcia, H. E., R. A. Locarnini, T. P. Boyer, J. I. Antonov, O. K. Baranova, M. M. Zweng, J. R. Reagan, D. R. Johnson, 2014. World Ocean Atlas 2013, Volume 3: Dissolved Oxygen, Apparent Oxygen Utilization, and Oxygen Saturation. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 75, 27 pp."
    "18" => "Garcia, H. E., K. Weathers, C. R. Paver, I. Smolyar, T. P. Boyer, R. A. Locarnini, M. M. Zweng, A. V. Mishonov, O. K. Baranova, D. Seidov, and J. R. Reagan, 2018. World Ocean Atlas 2018, Volume 3: Dissolved Oxygen, Apparent Oxygen Utilization, and Oxygen Saturation. A. Mishonov Technical Ed.; in preparation."
    _ => error("No citation for WOA$(my_product_year(year)) AOU. Add it if it should be there!")
end

citation_Nutrients(year) = @match my_product_year(year) begin
    "09" => "Garcia, H. E., R. A. Locarnini, T. P. Boyer, J. I. Antonov, M. M. Zweng, O. K. Baranova, and D. R. Johnson, 2010. World Ocean Atlas 2009, Volume 4: Nutrients (phosphate, nitrate, silicate). S. Levitus, Ed. NOAA Atlas NESDIS 71, U.S. Government Printing Office, Washington, D.C., 398 pp."
    "13" => "Garcia, H. E., R. A. Locarnini, T. P. Boyer, J. I. Antonov, O. K. Baranova, M. M. Zweng, J. R. Reagan, D. R. Johnson, 2014. World Ocean Atlas 2013, Volume 4: Dissolved Inorganic Nutrients (phosphate, nitrate, silicate). S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 76, 25 pp."
    "18" => "Garcia, H. E., K. Weathers, C. R. Paver, I. Smolyar, T. P. Boyer, R. A. Locarnini, M. M. Zweng, A. V. Mishonov, O. K. Baranova, D. Seidov, and J. R. Reagan, 2018. World Ocean Atlas 2018, Volume 4: Dissolved Inorganic Nutrients (phosphate, nitrate and nitrate+nitrite, silicate). A. Mishonov Technical Ed.; in preparation."
    _ => error("No citation for WOA$(my_product_year(year)) Nutrients. Add it if it should be there!")
end

# TODO Add other citations for other years!

