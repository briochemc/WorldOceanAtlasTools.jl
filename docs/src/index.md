# WorldOceanAtlasTools.jl Documentation

This package provides tools for downloading and using data from the [World Ocean Atlas (WOA)](https://en.wikipedia.org/wiki/World_Ocean_Atlas).

Like with every Julia package, you must start with

```julia
julia> using WorldOceanAtlasTools
```

By default, the latest WOA18 data is used.

Below are examples.

## Get WOA observations

To get a list of observations as a table, simply call `observations(tracer)`:

```julia
julia> Pobs = WorldOceanAtlasTools.observations("PO4")
Registering World Ocean Atlas data with DataDeps
┌ Warning: You are about to use World Ocean Atlas data 18.
│
│ Please cite the following corresponding reference(s):
│ Garcia et al. (2018), World Ocean Atlas 2018, Volume 4: Dissolved Inorganic Nutrients (phosphate, nitrate and nitrate+nitrite, silicate). A. Mishonov Technical Ed.; in preparation.)
└ @ WorldOceanAtlasTools ~/.julia/dev/WorldOceanAtlasTools/src/functions.jl:223
┌ Warning: Over-writing registration of the datadep
│   name = "WOA18_Annual_phosphate_360x180"
└ @ DataDeps ~/.julia/packages/DataDeps/ooWXe/src/registration.jl:15
1312523×4 DataFrame
     Row │ lat      lon      depth      PO4
         │ Float32  Float32  Quantity…  Quantity…
─────────┼────────────────────────────────────────────────
       1 │   -77.5   -178.5      0.0 m  1.35075 μmol kg⁻¹
       2 │   -77.5   -177.5      0.0 m  1.28211 μmol kg⁻¹
    ⋮    │    ⋮        ⋮         ⋮              ⋮
 1312522 │    52.5   -163.5   5500.0 m  2.42341 μmol kg⁻¹
 1312523 │    53.5   -158.5   5500.0 m  2.45224 μmol kg⁻¹
                                      1312519 rows omitted
```

## Get gridded WOA data

To get the 3D field of the "statistical mean" climatological concentration of phosphate from the World Ocean Atlas 2018 product at 5-degree resolution, use `get_3D_field`:

```julia
julia> WorldOceanAtlasTools.get_3D_field("PO4"; field="mn", resolution="5°")
Getting the 3D field of WOA18 Annual phosphate 73x36 data
Registering World Ocean Atlas data with DataDeps
┌ Warning: You are about to use World Ocean Atlas data 18.
│
│ Please cite the following corresponding reference(s):
│ Garcia et al. (2018), World Ocean Atlas 2018, Volume 4: Dissolved Inorganic Nutrients (phosphate, nitrate and nitrate+nitrite, silicate). A. Mishonov Technical Ed.; in preparation.)
└ @ WorldOceanAtlasTools ~/.julia/dev/WorldOceanAtlasTools/src/functions.jl:223
┌ Warning: Over-writing registration of the datadep
│   name = "WOA18_Annual_phosphate_73x36"
└ @ DataDeps ~/.julia/packages/DataDeps/ooWXe/src/registration.jl:15
  Rearranging data
36×72×102 Array{Union{Missing, Float32}, 3}:
[:, :, 1] =
  missing   missing  …   missing   missing
  missing   missing      missing   missing
 ⋮                   ⋱  ⋮
 0.563333  0.69         0.61      0.62
 0.78      0.455     …  0.525     0.638659

[:, :, 2] =
  missing   missing  …   missing   missing
  missing   missing      missing   missing
 ⋮                   ⋱  ⋮
 0.563014  0.69         0.612773  0.624986
 0.781124  0.446186  …  0.525     0.77

;;; …

[:, :, 101] =
 missing  missing  …  missing  missing
 missing  missing     missing  missing
 ⋮                 ⋱  ⋮
 missing  missing     missing  missing
 missing  missing  …  missing  missing

[:, :, 102] =
 missing  missing  …  missing  missing
 missing  missing     missing  missing
 ⋮                 ⋱  ⋮
 missing  missing     missing  missing
 missing  missing  …  missing  missing
```

## Regridding WOA data to an AIBECS grid

To "regrid" WOA data (using a nearest-neighbour algorithm) to an AIBECS grid, you can use `fit_to_grid`:

```julia
julia> using AIBECS

julia> grd, _ = OCIM2.load();
┌ Info: You are about to use the OCIM2_CTL_He model.
│ If you use it for research, please cite:
│
│ - DeVries, T., & Holzer, M. (2019). Radiocarbon and helium isotope constraints on deep ocean ventilation and mantle‐³He sources. Journal of Geophysical Research: Oceans, 124, 3036–3057. https://doi.org/10.1029/2018JC014716
│
│ You can find the corresponding BibTeX entries in the CITATION.bib file
│ at the root of the AIBECS.jl package repository.
└ (Look for the "DeVries_Holzer_2019" key.)

julia> μPO43D, σPO43D = WorldOceanAtlasTools.fit_to_grid(grd, "PO₄");
Registering World Ocean Atlas data with DataDeps
┌ Warning: You are about to use World Ocean Atlas data 18.
│
│ Please cite the following corresponding reference(s):
│ Garcia et al. (2018), World Ocean Atlas 2018, Volume 4: Dissolved Inorganic Nutrients (phosphate, nitrate and nitrate+nitrite, silicate). A. Mishonov Technical Ed.; in preparation.)
└ @ WorldOceanAtlasTools ~/.julia/dev/WorldOceanAtlasTools/src/functions.jl:223
┌ Warning: Over-writing registration of the datadep
│   name = "WOA18_Annual_phosphate_360x180"
└ @ DataDeps ~/.julia/packages/DataDeps/ooWXe/src/registration.jl:15
  Reading NetCDF file
  Rearranging data
  Filtering data
  Averaging data over each grid box
  Setting μ = 0 and σ² = ∞ where no obs
  Setting a realistic minimum for σ²
```

This will use the "objectively analyzed mean" (because it is more filled than the statistical mean), which is at 1° resolution.

You can check the size of `μPO43D` and rearrange it to work with model vectors:

```julia
julia> size(μPO43D), size(grd) # Check that the variable has the same size
((91, 180, 24), (91, 180, 24))

julia> PO4obs = vectorize(μPO43D, grd) # rearrange as a vector of wet-box values only
200160-element Vector{Float64}:
 1.916053578257561e-6
 1.9119117371737955e-6
 1.8802444487810134e-6
 ⋮
 1.5629494562745093e-6
 1.5608462169766426e-6
 1.544798031449318e-6
```


## Reference (function docstrings)

```@autodocs
Modules = [WorldOceanAtlasTools]
Order   = [:function, :type]
```
