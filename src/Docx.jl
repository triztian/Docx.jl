module Docx

using ZipFile

mutable struct Document
    _fileNames::Array{String}
end

"""
Open a document
"""
function open(docx_path::String)::Document
    zarchive = ZipFile.Reader(docx_path)

    doc = Document([])

    for file in zarchive.files 
        if endswith(file.name, ".xml")
            push!(doc._fileNames, file.name)
            # println(read(file, String))
        end
    end

    return doc
end

"""
Adds a heading to the end of the document
"""
function add_heading(document::Document)
end

end # module
