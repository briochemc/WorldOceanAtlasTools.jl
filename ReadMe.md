<a href="https://github.com/briochemc/WorldOceanAtlasTools.jl">
  <img src="https://user-images.githubusercontent.com/4486578/59411626-07e2ed00-8dff-11e9-8daf-e823f61124d9.png" width="100%" align="center">
</a>

# World Ocean Atlas Tools

<p>
  <a href="https://github.com/briochemc/WorldOceanAtlasTools.jl/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/briochemc/WorldOceanAtlasTools.jl/mac.yml?label=OSX&logo=Apple&logoColor=white&style=flat-square">
  </a>
  <a href="https://github.com/briochemc/WorldOceanAtlasTools.jl/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/briochemc/WorldOceanAtlasTools.jl/linux.yml?label=Linux&logo=Linux&logoColor=white&style=flat-square">
  </a>
  <a href="https://github.com/briochemc/WorldOceanAtlasTools.jl/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/briochemc/WorldOceanAtlasTools.jl/windows.yml?label=Windows&logo=Windows&logoColor=white&style=flat-square">
  </a>
  <a href="https://codecov.io/gh/briochemc/WorldOceanAtlasTools.jl">
    <img src="https://img.shields.io/codecov/c/github/briochemc/WorldOceanAtlasTools.jl/master?label=Codecov&logo=codecov&logoColor=white&style=flat-square">
  </a>
</p>

<p>
  <a href="https://briochemc.github.io/WorldOceanAtlasTools.jl/stable/">
    <img src="https://img.shields.io/github/actions/workflow/status/briochemc/WorldOceanAtlasTools.jl/docs.yml?style=for-the-badge&label=Documentation&logo=Read%20the%20Docs&logoColor=white">
  </a>
</p>

<p>
  <a href="https://doi.org/10.5281/zenodo.2677666">
    <img src="https://zenodo.org/badge/DOI/10.5281/zenodo.2677666.svg" alt="DOI">
  </a>
  <a href="https://github.com/briochemc/WorldOceanAtlasTools.jl/blob/master/LICENSE">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg">
  </a>
</p>

### Simple usage

Just add WorldOceanAtlasTools like any other Julia package, and then you can grab the data with, e.g.,

```julia
julia> WorldOceanAtlasTools.observations("PO₄")
Registering World Ocean Atlas data with DataDeps
┌ Warning: You are about to use World Ocean Atlas data.
│ Please cite the following corresponding reference(s):
│ Garcia, H. E., K. Weathers, C. R. Paver, I. Smolyar, T. P. Boyer, R. A. Locarnini, M. M. Zweng, A. V. Mishonov, O. K. Baranova, D. Seidov, and J. R. Reagan, 2018. World Ocean Atlas 2018, Volume 4: Dissolved Inorganic Nutrients (phosphate, nitrate and nitrate+nitrite, silicate). A. Mishonov Technical Ed.; in preparation.)
└ @ WorldOceanAtlasTools ~/.julia/dev/WorldOceanAtlasTools/src/functions.jl:218
1312523×4 DataFrame
     Row │ lat      lon      depth      PO₄
         │ Float32  Float32  Quantity…  Quantity…
─────────┼────────────────────────────────────────────────
       1 │   -77.5   -178.5      0.0 m  1.35075 μmol kg⁻¹
       2 │   -77.5   -177.5      0.0 m  1.28211 μmol kg⁻¹
       3 │   -77.5   -176.5      0.0 m  1.37447 μmol kg⁻¹
    ⋮    │    ⋮        ⋮         ⋮              ⋮
 1312521 │    52.5   -165.5   5500.0 m  2.4566 μmol kg⁻¹
 1312522 │    52.5   -163.5   5500.0 m  2.42341 μmol kg⁻¹
 1312523 │    53.5   -158.5   5500.0 m  2.45224 μmol kg⁻¹
                                      1312517 rows omitted
```


### Why this package?

[WorldOceanAtlasTools.jl](https://github.com/briochemc/WorldOceanAtlasTools.jl) was developed for the purpose of downloading and using data from the World Ocean Atlas (WOA) database to be used by the [AIBECS.jl](https://github.com/briochemc/AIBECS.jl) package.
The more generic ambition is for [WorldOceanAtlasTools.jl](https://github.com/briochemc/WorldOceanAtlasTools.jl) to provide an API that can fetch data from [this list](https://www.nodc.noaa.gov/OC5/indprod.html) of WOA data sets and products (located on the National Oceanic and Atmospheric Administration (NOAA) wesbite) and fit it to any model's grid.

This is a work in progress, therefore PRs, suggestions, and generally help are, of course, more than welcome!

### How it works

[WorldOceanAtlasTools.jl](https://github.com/briochemc/WorldOceanAtlasTools.jl) essentially defines the nomenclature and URLs used by the WOA and then relies on the [DataDeps.jl](https://github.com/oxinabox/DataDeps.jl) package developed by [White et al. (2018)](https://arxiv.org/abs/1808.01091) to download the corresponding NetCDF files.
(NetCDF files are read using the [NCDatasets.jl](https://github.com/Alexander-Barth/NCDatasets.jl) package.)

In order to facilitate the use of WOA data in [AIBECS.jl](https://github.com/briochemc/AIBECS.jl), the [WorldOceanAtlasTools.jl](https://github.com/briochemc/WorldOceanAtlasTools.jl) package can use a `grid` from the [OceanGrids.jl](https://github.com/briochemc/OceanGrids.jl) package and bin a WOA tracer into that grid, and uses the [NearestNeighbors.jl](https://github.com/KristofferC/NearestNeighbors.jl) package to decide where to bin each observation.

But you can also use it as in the example snippet above by simply calling the function `observations`.

### Cite me if you use me!

If you use this package, please cite it using the [CITATION.bib](./CITATION.bib) file, and cite the WOA references using the `citation` function or use the corresponding bibtex entries in the [CITATION.bib](./CITATION.bib) file. 
