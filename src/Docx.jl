module Docx

using ZipFile

mutable struct DocxFile
    _zipFile::ZipFile.ReadableFile 

    name::String
    extension::String

    string_contents::Union{String, Nothing}
    binary_contents::Union{UInt8, Nothing}
end

function read_string(docx_file::DocxFile)::String
    read(docx_file._zipFile, String)
end

function read_binary(docx_file::DocxFile)::Vector{UInt8}
    read(docx_file._zipFile, UInt8)
end

mutable struct Document
    _files::Vector{DocxFile}
end

"""
Open a document
"""
function open(docx_path::String)::Document
    zarchive = ZipFile.Reader(docx_path)

    doc = Document([])

    for file in zarchive.files 
        ext = last(split(file.name, "."))
        name = first(split(file.name, "."))
        df = DocxFile(file, name, ext, nothing, nothing)
        push!(doc._files, df)
    end

    return doc
end

"""
Adds a heading to the end of the document
"""
function add_heading(document::Document)
end

end # module
