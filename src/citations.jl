function citation(tracer; product_year=2018)
    yr_str = my_product_year(product_year)
    @match my_varname(tracer) begin
        "DSi" || "DIP" || "DIN" => citation_Nutrients(yr_str)
        "Temp" => citation_Temperature(yr_str)
        "Salt" => citation_Salinity(yr_str)
        "O2" || "O2sat" || "AOU" => citation_Oxygen(yr_str)
        "Dens" || "Cond" => citation(yr_str)
        _ => error("Not sure what you are trying to cite.")
    end
end

citation(product_year) = @match my_product_year(product_year) begin
    "13" => "Boyer, T. P. et al. (2013): World Ocean Database 2013, NOAA Atlas NESDIS 72, S. Levitus, Ed., A. Mishonov, Technical Ed.; Silver Spring, MD, 209 pp., doi:10.7289/V5NZ85MT"
    "18" => "Boyer, T. P. et al. (2018): World Ocean Database 2018. A. V. Mishonov, Technical Editor, NOAA Atlas NESDIS 87."
    _ => "I could not find a citation for WOD$(my_product_year(product_year)). Add it if you know where to find it!"
end

citation_Temperature(product_year) = @match my_product_year(product_year) begin
    "09" => "Locarnini et al. (2010), World Ocean Atlas 2009, Volume 1: Temperature. S. Levitus, Ed. NOAA Atlas NESDIS 68, U.S. Government Printing Office, Washington, D.C., 184 pp."
    "13" => "Locarnini et al. (2013), World Ocean Atlas 2013, Volume 1: Temperature. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 73, 40 pp."
    "18" => "Locarnini et al. (2018), World Ocean Atlas 2018, Volume 1: Temperature. A. Mishonov Technical Ed.; in preparation."
    "23" => "Locarnini et al. (2023), World Ocean Atlas 2023, Volume 1: Temperature. A. Mishonov Technical Ed.; NOAA Atlas NESDIS 89, 52 pp, https://doi.org/10.25923/54bh-1613"
    _ => error("No citation for WOA$(my_product_year(product_year)) Temperature. Add it if it should be there!")
end

citation_Salinity(product_year) = @match my_product_year(product_year) begin
    "09" => "Antonov et al. (2010), World Ocean Atlas 2009, Volume 2: Salinity. S. Levitus, Ed. NOAA Atlas NESDIS 69, U.S. Government Printing Office, Washington, D.C., 184 pp."
    "13" => "Zweng et al. (2013), World Ocean Atlas 2013, Volume 2: Salinity. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 74, 39 pp."
    "18" => "Zweng et al. (2018), World Ocean Atlas 2018, Volume 2: Salinity. A. Mishonov Technical Ed.; in preparation."
    "23" => "Reagan, et al. (2023), World Ocean Atlas 2023, Volume 2: Salinity. A. Mishonov Technical Ed.; NOAA Atlas NESDIS 90, 51pp. https://doi.org/10.25923/70qt-9574"
    _ => error("No citation for WOA$(my_product_year(product_year)) Salinity. Add it if it should be there!")
end

citation_Oxygen(product_year) = @match my_product_year(product_year) begin
    "09" => "Garcia et al. (2010), World Ocean Atlas 2009, Volume 3: Dissolved Oxygen, Apparent Oxygen Utilization, and Oxygen Saturation. S. Levitus, Ed. NOAA Atlas NESDIS 70, U.S. Government Printing Office, Washington, D.C., 344 pp."
    "13" => "Garcia et al. (2014), World Ocean Atlas 2013, Volume 3: Dissolved Oxygen, Apparent Oxygen Utilization, and Oxygen Saturation. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 75, 27 pp."
    "18" => "Garcia et al. (2018), World Ocean Atlas 2018, Volume 3: Dissolved Oxygen, Apparent Oxygen Utilization, and Oxygen Saturation. A. Mishonov Technical Ed.; in preparation."
    "23" => "Garcia et al. (2023), World Ocean Atlas 2023, Volume 3: Dissolved Oxygen, Apparent Oxygen Utilization, and Oxygen Saturation. A. Mishonov Technical Ed.; NOAA Atlas NESDIS 91, 34pp, https://doi.org/10.25923/rb67-ns53"
    _ => error("No citation for WOA$(my_product_year(product_year)) AOU. Add it if it should be there!")
end

citation_Nutrients(product_year) = @match my_product_year(product_year) begin
    "09" => "Garcia et al. (2010), World Ocean Atlas 2009, Volume 4: Nutrients (phosphate, nitrate, silicate). S. Levitus, Ed. NOAA Atlas NESDIS 71, U.S. Government Printing Office, Washington, D.C., 398 pp."
    "13" => "Garcia et al. (2014), World Ocean Atlas 2013, Volume 4: Dissolved Inorganic Nutrients (phosphate, nitrate, silicate). S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 76, 25 pp."
    "18" => "Garcia et al. (2018), World Ocean Atlas 2018, Volume 4: Dissolved Inorganic Nutrients (phosphate, nitrate and nitrate+nitrite, silicate). A. Mishonov Technical Ed.; in preparation."
    "23" => "Garcia et al. (2023), World Ocean Atlas 2023, Volume 4: Dissolved Inorganic Nutrients (phosphate, nitrate and nitrate+nitrite, silicate). A. Mishonov Technical Ed.; NOAA Atlas NESDIS 92, 34pp, https://doi.org/10.25923/39qw-7j08"
    _ => error("No citation for WOA$(my_product_year(product_year)) Nutrients. Add it if it should be there!")
end

# TODO Add other citations for other years!

