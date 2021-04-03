using Docx, Test

if isempty(ARGS) || "all" in ARGS
	all_tests = true
else
	all_tests = false
end

if all_tests || "test.docx" in ARGS
	@testset "test.docx" begin
		docx_path = string(@__DIR__, "/test_files/test.docx")

		doc = Docx.open(docx_path)
		result = Docx.read(doc, String)

		@test result == """
		python-docx was here!
		python-docx was here too!
		"""
	end
end

if all_tests || "style_table_shape.docx" in ARGS
	@testset "style_table_shape.docx" begin
		docx_path = string(@__DIR__, "/test_files/style_table_shape.docx")

		doc = Docx.open(docx_path)
		result = Docx.read(doc, String)

		println(result)
	end
end