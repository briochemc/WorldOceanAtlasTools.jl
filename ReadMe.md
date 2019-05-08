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
  <a href='https://coveralls.io/github/briochemc/WorldOceanAtlasTools.jl'>
    <img src='https://coveralls.io/repos/github/briochemc/WorldOceanAtlasTools.jl/badge.svg' alt='Coverage Status' />
  </a>
</p>
<p>
  <a href="https://codecov.io/gh/briochemc/WorldOceanAtlasTools.jl">
    <img src="https://codecov.io/gh/briochemc/WorldOceanAtlasTools.jl/branch/master/graph/badge.svg" />
  </a>
  <a href="https://ci.appveyor.com/project/briochemc/WorldOceanAtlasTools-jl">
    <img alt="Build Status" src="https://ci.appveyor.com/api/projects/status/76lcl30w1uxbirx2?svg=true">
  </a>
</p>


This package was developed for the purpose of downloading and using data from the World Ocean Atlas (WOA) database.
The goal is to provide an API that has access to parts of [this list](https://www.nodc.noaa.gov/OC5/indprod.html) of WOA data sets and products (located on the National Oceanic and Atmospheric Administration (NOAA) wesbite).

This is a work in progress although it is currently used by the [AIBECS.jl](https://github.com/briochemc/AIBECS.jl) package and depending projects.
PRs, suggestions, and generally help are, of course, more than welcome!

WorldOceanAtlasTools essentially defines the nomenclature and URLs used by the World Ocean Atlas and then relies on the [DataDeps.jl](https://github.com/oxinabox/DataDeps.jl) package developed by [White et al. (2018)](https://arxiv.org/abs/1808.01091) to download the corresponding NetCDF files.
(NetCDF files are read using the [NCDatasets.jl](https://github.com/Alexander-Barth/NCDatasets.jl) package.)

