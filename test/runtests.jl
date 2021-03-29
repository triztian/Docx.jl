using Docx, Test

@testset "open" begin
    docx_path = string(@__DIR__, "/test_files/test.docx")
    println("Test Docx", docx_path)

    doc = Docx.open(docx_path)
    result = Docx.read_plaintext(doc)

    @test result == """
    python-docx was here!
    python-docx was here too!
    """
end