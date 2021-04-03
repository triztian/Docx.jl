
using EzXML


"""
Read the contents of the document as a string.

  * Header text will be clustered
  * Paragraphs will be separated by new lines.
  * Footnotes will be clustered 
"""
function read(docx::Document, ::Type{String})::String 
    plaintext = ""

    for (i, file) in enumerate(docx._files)
        if file.extension != "xml"
			continue
        end

		str = strip(_extract_text(read!(file, String)))
		if !isempty(str)
			plaintext *= str

			if i < length(docx._files)
				plaintext *= "\n"
			end
		end
    end

    plaintext
end

"""
A type that indicates to return the contents as XML strings
"""
abstract type XML end

"""
	read(docx, XML)

Reads the contents of the document and returns them as a plain string

  * Header text will be clustered
  * Paragraphs will be separated by new lines.
  * Footnotes will be clustered 
"""
function read(docx::Document, ::Type{XML})::String
	xml_nodes = ""
    for (i, file) in enumerate(docx._files)
        if file.extension == "xml"
			xml_nodes *= read!(file, String)
        end
    end

	xml_nodes
end

"""
Reads the docfile contents as a string
"""
function read!(docx_file::DocxFile, ::Type{String})::String
    if docx_file.string_contents !== nothing
        return docx_file.string_contents::String
    end

    str = Base.read(docx_file._zipFile, String)
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
    text = ""

    doc = parsexml(xml_string)
    root_elem = root(doc)

    elems = _flatten(root_elem)
    for (i, elem) in enumerate(elems)
		if elem.name == "p"
			text *= "\n"
		end

        if _is_docx_text_node(elem)
            text *= nodecontent(elem)
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