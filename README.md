# OdsReaders

[![Build Status](https://travis-ci.org/mkatase/OdsReaders.jl.svg?branch=master)](https://travis-ci.org/mkatase/OdsReaders.jl)
[![codecov](https://codecov.io/gh/mkatase/OdsReaders.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/mkatase/OdsReaders.jl)

OdsReaders is a package that provides functionality to read OpenDocument Spreadsheet (e.g. LibreOffice Calc) files.

## Environment

* Fedora 31 **5.3.7-301**
* Julia **1.2**
* PyCall **v1.91.2**

## Install Python library

The package uses the Python pyexcel-ods library. If this library is not installed on using Python, please install by pip command.

```python
$ pip install pyexcel-ods
```

## Setting up PyCall

If PyCall pacakge is not installed, ENV["PYTHON"] variable set up, build and test procedure.

```julia
v1.x> pkg> ENV["PYTHON"] = "/path/to/bin/python"
v1.x> pkg> add PyCall
v1.x> pkg> build PyCall
v1.x> pkg> test PyCall
...
   Testing PyCall tests passed 

(v1.x) pkg> 
```

## Install OdsReaders.jl

```julia
julia> using Pkg
julia> Pkg.clone("https://github.com/mkatase/OdsReaders.jl.git")
julia> Pkg.test("OdsReaders")
...
   Testing OdsReaders
 Resolving package versions...
# sheet check
...
# search string Z in Sheet4
Test Summary: | Pass  Total
OdsReaders    |   53     53
   Testing OdsReaders tests passed 
```

or

```julia
(v1.x) pkg> add https://github.com/mkatase/OdsReaders.jl.git
  Updating registry at `~/.julia/registries/General`
...
  [d106bba2] + OdsReaders v0.2.0 #master (https://github.com/mkatase/OdsReaders.jl.git)

(v1.x) pkg> activate .

(OdsReaders) pkg> test
   Testing OdsReaders
 Resolving package versions...
# sheet check
...
# search string Z in Sheet4
Test Summary: | Pass  Total
OdsReaders    |   53     53
   Testing OdsReaders tests passed 

(OdsReaders) pkg> 
```

## How to use OdsReaders package in Julia

At first, set up to use OdsReaders package.

```julia
julia> using OdsReaders
```

## Reading a whole sheet

```julia
julia> data = openods("Filename.ods")
```

This will return an OrderedDict with all sheet in Filename.ods.
If no file, return nothing.

## Reading a specific sheet

```julia
julia> data = readsheet("Filename.ods", "Sheet1")
```

This will return an array data with *Sheet1* sheet in Filename.ods.
If no sheet, return empty array.

## Reading a specific sheet skipping first row

First row is used header in many cases.
For skipping first row is:

```julia
julia> data = readsheet("Filename.ods", "Sheet1" ; header=true)
```

## Getting sheet lists

```julia
julia> lists = getsheets("Filename.ods")
```

This will return an array data in Filename.ods.

## Searching number or string in file

```julia
julia> dict = searchods("Filename.ods", 4)    # seach 4 (integer)
julia> dict = searchods("Filename.ods", "X")  # seach X (string)
```

## Searching number or string in a specific sheet

```julia
julia> dict = searchsheet("Filename.ods", "Sheet1", 5)   # search 5 in Sheet1
julia> dict = searchsheet("Filename.ods", "Sheet2", "X") # search X in Sheet2
```

## For example

``example.jl`` draws a graph using ``PyPlot`` and ``test/TestData.ods``.

```bash
$ cd example
$ julia example.jl
```

## Thanks
I'm developing this package based on the following package. Thanks.

* [ExcelReaders.jl](https://github.com/queryverse/ExcelReaders.jl)
