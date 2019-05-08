# WorldOceanAtlasTools.jl Documentation

This package provides tools for downloading and using data from the [World Ocean Atlas (WOA)](https://en.wikipedia.org/wiki/World_Ocean_Atlas).

This documentation is work in progress!

To use the package, make sure you add it before!

## WOA 2D surface maps

```@meta
DocTestSetup = quote
    using WorldOceanAtlasTools
end
```

This is an example use of the software.
Here is an example to download the 3D field of the concentration of phosphate for the month of February from the World Ocean Atlas 2018 product at 5-degree resolution.

```jldoctest usage
P3D = WorldOceanAtlasTools.get_3D_field(2018, "phosphate", "Feb", "5°", "mean")
size(P3D)

# output

(36, 72, 43)
```

## Fitting a 3D field from WOA to another grid

TODO

## Functions

```@docs
get_3D_field(product_year, tracer, period, resolution, field)
```
