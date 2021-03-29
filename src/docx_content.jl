
using EzXML

"""
"""
function read_plaintext(docx::Document)::String 
    plaintext = ""

    # TODO: Probably rewrite to be less nested
    for (i, file) in enumerate(docx._files)
        if file.extension == "xml"
            str = strip(_extract_text(read_string!(file)))
            if !isempty(str)
                plaintext *= str

                if i < length(docx._files)
                    plaintext *= "\n"
                end
            end
        end
    end

    plaintext
end

"""
Reads the docfile contents as a string
"""
function read_string!(docx_file::DocxFile)::String
    if docx_file.string_contents !== nothing
        return docx_file.string_contents::String
    end

    str = read(docx_file._zipFile, String)
    docx_file.string_contents = str
    return str
end

"""
Reads the docfile contents as a string
"""
function read_binary!(docx_file::DocxFile)::Vector{UInt8}
    if docx_file.binary_contents !== nothing
        return docx_file.binary_contents
    end

    bin = read(docx_file._zipFile, UInt8)
    docx_file.binary_contents
    return bin
end

"""
Extracts text elements from the given XML structure
"""
function _extract_text(xml_string::String)::String
    # Get the root element from `doc`.
    text = ""
    # println(xml_string)
    doc = parsexml(xml_string)
    root_elem = root(doc)

    elems = _flatten(root_elem)
    # println(elems)
    for (i, elem) in enumerate(elems)
        if _is_docx_text_node(elem)
            text *= nodecontent(elem)
            if i < length(elems)
                text *= "\n"
            end
        end
    end

    text
end

const word_processing_xmlns_2006 = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"

const text_content_nodes = [
    "t"
]

"""
Determines whether the XML node element contains text data or not.
"""
_is_docx_text_node(elem) = 
    elem.namespace == word_processing_xmlns_2006 && nodename(elem) in text_content_nodes

"""
Creates an array of all the XML nodes by pushing into an array as the root node and children are 
traversed.
"""
function _flatten(node::EzXML.Node)::Array{EzXML.Node}
    elems = [node]
    for elem in eachelement(node)
        for subelem in _flatten(elem)
            push!(elems, subelem)
        end
    end

    elems
end