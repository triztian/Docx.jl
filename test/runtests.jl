using Docx, Test

@testset "open" begin
    docx_path = string(@__DIR__, "/test_files/having-images.docx")
    println("Test Docx", docx_path)

    doc = Docx.open(docx_path)
    for fileName in doc._fileNames 
        println(fileName)
    end
end