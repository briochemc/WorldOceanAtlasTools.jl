"""
    convert_WOAunits_to_unitful(s)

Converts the string from WOA's `units` attribute to a Unitful.jl unit.
"""
convert_to_Unitful(v::String) = @match v begin
    "micromoles_per_liter"             => u"μmol/l"
    "micromoles_per_kilogram"          => u"μmol/kg"
    "percent"                          => u"percent"
    "meters"                           => u"m"
    "degrees_north"                    => u"°"
    "degrees_east"                     => u"°"
    "degrees_celsius"                  => u"°C"
    _ => nothing
end




