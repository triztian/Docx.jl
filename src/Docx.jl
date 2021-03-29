module Docx

using ZipFile

mutable struct DocxFile
    _zipFile::ZipFile.ReadableFile 
    _read::Bool

    name::String
    extension::String

    string_contents::Union{String, Nothing}
    binary_contents::Union{UInt8, Nothing}
end


mutable struct Document
    _files::Vector{DocxFile}
end

include("docx_content.jl")

"""
Open a document
"""
function open(docx_path::String)::Document
    zarchive = ZipFile.Reader(Base.open(docx_path))

    doc = Document([])

    for file in zarchive.files 
        ext = last(split(file.name, "."))
        name = first(split(file.name, "."))
        df = DocxFile(file, false, name, ext, nothing, nothing)
        push!(doc._files, df)
    end

    return doc
end

end # module
