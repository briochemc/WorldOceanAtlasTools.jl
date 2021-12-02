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

julia> WorldOceanAtlasTools.fit_to_grid(grd, "PO₄")
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
([0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 8.37903393432498e-7 8.176308069378138e-7 … 8.838544953614473e-7 8.606970310211181e-7; 7.861683554947376e-7 7.814608607441186e-7 … 7.965100686997175e-7 7.912108264863491e-7;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 9.173616511481148e-7 8.972513271229607e-7 … 9.63796432529177e-7 9.399399778672627e-7; 9.184250427143914e-7 9.139957534415382e-7 … 9.28854546376637e-7 9.234159354652676e-7;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 9.644730364282925e-7 9.464122727513312e-7 … 1.0045114383101463e-6 9.843422373135884e-7; 9.78905476629734e-7 9.748196577032407e-7 … 9.874233603477478e-7 9.82965737581253e-7;;; … ;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 9.87605482339859e-7 9.836060777306556e-7 … 9.862938821315764e-7 9.878723753823174e-7; 1.003702774643898e-6 1.0033106356859206e-6 … 9.999448239803314e-7 9.996009171009064e-7;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0], [Inf Inf … Inf Inf; Inf Inf … Inf Inf; … ; 2.042927652604165e-15 2.1164168635279256e-15 … 1.8804305222925864e-15 1.950211218115783e-15; 3.975961076304934e-15 3.788123497757034e-15 … 4.4919021353958535e-15 4.194942922028044e-15;;; Inf Inf … Inf Inf; Inf Inf … Inf Inf; … ; 1.5905362107163645e-15 1.5728557377215901e-15 … 1.6612531530059148e-15 1.6186905767422433e-15; 3.247439492867432e-15 3.227955031685825e-15 … 3.445652802771204e-15 3.318702992950229e-15;;; Inf Inf … Inf Inf; Inf Inf … Inf Inf; … ; 4.393185643835285e-15 4.045568888527362e-15 … 5.383088611798703e-15 4.8431861345832326e-15; 3.152660584876177e-15 3.1826269983549205e-15 … 3.2664105171006373e-15 3.190998478472373e-15;;; … ;;; Inf Inf … Inf Inf; Inf Inf … Inf Inf; … ; 2.7769844958639746e-16 2.7769844958639746e-16 … 2.7769844958639746e-16 2.7769844958639746e-16; 2.7769844958639746e-16 2.7769844958639746e-16 … 2.7769844958639746e-16 2.7769844958639746e-16;;; Inf Inf … Inf Inf; Inf Inf … Inf Inf; … ; Inf Inf … Inf Inf; Inf Inf … Inf Inf;;; Inf Inf … Inf Inf; Inf Inf … Inf Inf; … ; Inf Inf … Inf Inf; Inf Inf … Inf Inf])
```

This will use the "objectively analyzed mean" (because it is more filled than the statistical mean), which is at 1° resolution.

## Reference (function docstrings)

```@docs
get_3D_field
get_gridded_3D_field
fit_to_grid
observations
```
