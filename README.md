# Docx.jl

> **NOTICE:** THIS SOFTWARE IS UNDER DEVELOPMENT AND ITS API IS NOT YET STABLE

A pure Julia package to work with Docx (Word) documents. 

This package aims to easily integrate with the packages of the [JuliaText](https://github.com/JuliaText) organization.

 * This package is heavily inspired by [python-docx](https://github.com/python-openxml/python-docx)

## Installation

```julia
julia> using Pkg; Pkg.add("Docx")
```

### Usage

```julia
using Docx

document = Docx.open("/path/to/document.docx")
```

Obtaining the plain text from the document:

```julia
Docx.read(document, String)
```
