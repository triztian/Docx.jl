# Docx.jl

> **NOTICE:** THIS SOFTWARE IS UNDER DEVELOPMENT AND ITS API IS NOT YET STABLE

A package to read Docx (Word) documents.

This package is heavily inspired by [python-docx](https://github.com/python-openxml/python-docx)


## Installation

```julia
julia> using Pkg; Pkg.add("Docx")
```

### Usage

```julia
using Docx

document = Docx.open("/path/to/document.docx")
```
