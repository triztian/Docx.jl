using Docx, Test

@testset "open" begin
    docx_path = string(@__DIR__, "/test_files/test.docx")
    println("Test Docx", docx_path)

    doc = Docx.open(docx_path)
    for file in doc._files
        println("=========== ")
        println("ZipName: ", file._zipFile.name)
        println("Name: ", file.name)
        println("Extension: ", file.extension)

        # if file.name == "[Content_Types]"
        #     println(Docx.read_string(file))
        # end
        
        if file.name == "word/document"
            println(Docx.read_string(file))
        end

        # if file.extension == "xml"
        #     println(Docx.read_string(file))
        # end
        println()
    end
end