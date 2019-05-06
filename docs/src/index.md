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
To download surface maps, simply call `WOA_surface_map(WOA_year, tracer_name, period, resolution)`.
For example, for the surface map of the concentration of phosphate for the month of February from the WOA18 product at 5-degree resolution.

```jldoctest usage
lat, lon, my_map = WorldOceanAtlasTools.WOA_surface_map(2018, "p", 2, "5")
size(my_map)

# output

(36, 72)
```

## WOA 3D fields

TODO

## Interpolating 3D fields to another model grid

TODO


