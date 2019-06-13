<a href="https://github.com/briochemc/WorldOceanAtlasTools.jl">
  <img src="https://user-images.githubusercontent.com/4486578/59411626-07e2ed00-8dff-11e9-8daf-e823f61124d9.png" width="100%" align="center">
</a>

# World Ocean Atlas Tools

<p>
  <a href="https://doi.org/10.5281/zenodo.2677666">
    <img src="https://zenodo.org/badge/DOI/10.5281/zenodo.2677666.svg" alt="DOI">
  </a>
  <a href="https://github.com/briochemc/WorldOceanAtlasTools.jl/blob/master/LICENSE">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg">
  </a>
</p>
<p>
  <a href="https://briochemc.github.io/WorldOceanAtlasTools.jl/stable/">
    <img src=https://img.shields.io/badge/docs-stable-blue.svg>
  </a>
  <a href="https://briochemc.github.io/WorldOceanAtlasTools.jl/latest/">
    <img src=https://img.shields.io/badge/docs-dev-blue.svg>
  </a>
</p>
<p>
  <a href="https://travis-ci.com/briochemc/WorldOceanAtlasTools.jl">
    <img alt="Build Status" src="https://travis-ci.com/briochemc/WorldOceanAtlasTools.jl.svg?branch=master">
  </a>
  <a href='https://coveralls.io/github/briochemc/WorldOceanAtlasTools.jl?branch=master'>
    <img src='https://coveralls.io/repos/github/briochemc/WorldOceanAtlasTools.jl/badge.svg?branch=master' alt='Coverage Status' />
  </a>
</p>
<p>
  <a href="https://ci.appveyor.com/project/briochemc/WorldOceanAtlasTools-jl">
    <img alt="Build Status" src="https://ci.appveyor.com/api/projects/status/76lcl30w1uxbirx2?svg=true">
  </a>
  <a href="https://codecov.io/gh/briochemc/WorldOceanAtlasTools.jl">
    <img src="https://codecov.io/gh/briochemc/WorldOceanAtlasTools.jl/branch/master/graph/badge.svg" />
  </a>
</p>


[WorldOceanAtlasTools.jl](https://github.com/briochemc/WorldOceanAtlasTools.jl) was developed for the purpose of downloading and using data from the World Ocean Atlas (WOA) database to be used by the [AIBECS.jl](https://github.com/briochemc/AIBECS.jl) package.
The more generic ambition is for [WorldOceanAtlasTools.jl](https://github.com/briochemc/WorldOceanAtlasTools.jl) to provide an API that can fetch data from [this list](https://www.nodc.noaa.gov/OC5/indprod.html) of WOA data sets and products (located on the National Oceanic and Atmospheric Administration (NOAA) wesbite) and fit it to any model's grid.

This is a work in progress, therefore PRs, suggestions, and generally help are, of course, more than welcome!

[WorldOceanAtlasTools.jl](https://github.com/briochemc/WorldOceanAtlasTools.jl) essentially defines the nomenclature and URLs used by the WOA and then relies on the [DataDeps.jl](https://github.com/oxinabox/DataDeps.jl) package developed by [White et al. (2018)](https://arxiv.org/abs/1808.01091) to download the corresponding NetCDF files.
(NetCDF files are read using the [NCDatasets.jl](https://github.com/Alexander-Barth/NCDatasets.jl) package.)

In order to facilitate the use of WOA data in [AIBECS.jl](https://github.com/briochemc/AIBECS.jl), the [WorldOceanAtlasTools.jl](https://github.com/briochemc/WorldOceanAtlasTools.jl) package can use a `grid` from the [OceanGrids.jl](https://github.com/briochemc/OceanGrids.jl) package and bin a WOA tracer into that grid, and uses the [NearestNeighbors.jl](https://github.com/KristofferC/NearestNeighbors.jl) package to decide where to bin each observation.

If you use this package, please cite it using the [CITATION.bib](./CITATION.bib) file, and cite the WOA references using the `citation` function or use the corresponding bibtex entries in the [CITATION.bib](./CITATION.bib) file. 
