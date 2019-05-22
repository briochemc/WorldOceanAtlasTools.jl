"""
    convert_WOAunits_to_unitful(s)

Converts the string from WOA's `units` attribute to a Unitful.jl unit.
"""
convert_to_Unitful(s) = UNITFUL_WOA[s]

#=====================================
Dictionary to translate
units from WOA
to units of Unitful
=====================================#

const UNITFUL_WOA = Dict(
    "micromoles_per_liter"    => u"μmol/l",
    "micromoles_per_kilogram" => u"1.025μmol/l", # 1 l ≈ 1.025 kg from ocean.ices.dk/Tools/UnitConversion.aspx
    "percent" => u"percent"
)
