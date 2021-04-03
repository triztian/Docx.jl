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

		# TODO: Handle de-duplication of "Shape 1 Text"
		# TODO: Add support for producing a "markdown" table
		expected = """
Docx.jl Sample Document 2

This sample document contains various styles and objects that contain text.

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

This is an italics paragraph.

This is a BOLD paragraph.

This is an underlined paragraph

Column 1
Column 2
Column 3
R1C1
R1C2
R1C3
R2C1
R2C2
R2C3



Shape 1 Text
Shape 1 Text
"""
		@test length(result) == length(expected)
		for i = 1:length(expected)
			@test result[i] == expected[i]
			@test codepoint(result[i]) ==  codepoint(expected[i])

			if codepoint(result[i]) != codepoint(expected[i])
				println("nth[$i]")
				println(expected[1:i])
				println("---")
				println(result[1:i])
				return
			end
		end
	end
end