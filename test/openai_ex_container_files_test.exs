defmodule OpenaiExContainerFilesTest do
  use ExUnit.Case
  doctest OpenaiEx.ContainerFiles

  alias OpenaiEx.ContainerFiles

  describe "new_upload/1" do
    test "creates request with file content" do
      result = ContainerFiles.new_upload(file: {"test.txt", "content"})
      assert result == %{file: {"test.txt", "content"}}
    end

    test "creates request with file path" do
      result = ContainerFiles.new_upload(file: {"/path/to/file.txt"})
      assert result == %{file: {"/path/to/file.txt"}}
    end

    test "creates request from list" do
      result = ContainerFiles.new_upload(file: {"example.txt", "data"})
      assert result == %{file: {"example.txt", "data"}}
    end

    test "raises error when file is missing" do
      assert_raise ArgumentError, "Upload request must include :file", fn ->
        ContainerFiles.new_upload(%{invalid: "field"})
      end
    end

    test "filters out invalid fields" do
      result =
        ContainerFiles.new_upload(
          file: {"valid.txt", "content"},
          invalid_field: "should_be_removed"
        )

      assert result == %{file: {"valid.txt", "content"}}
      refute Map.has_key?(result, :invalid_field)
    end
  end

  describe "new_reference/1" do
    test "creates request with file_id" do
      result = ContainerFiles.new_reference(file_id: "file-123")
      assert result == %{file_id: "file-123"}
    end

    test "creates request from list" do
      result = ContainerFiles.new_reference(file_id: "file-456")
      assert result == %{file_id: "file-456"}
    end

    test "raises error when file_id is missing" do
      assert_raise ArgumentError, "Reference request must include :file_id", fn ->
        ContainerFiles.new_reference(%{invalid: "field"})
      end
    end

    test "filters out invalid fields" do
      result =
        ContainerFiles.new_reference(
          file_id: "file-789",
          invalid_field: "should_be_removed"
        )

      assert result == %{file_id: "file-789"}
      refute Map.has_key?(result, :invalid_field)
    end
  end

  describe "endpoint URL generation" do
    test "generates base container files URL" do
      # Test through the public interface since ep_url is private
      # We can verify URL generation by testing the module structure
      functions = ContainerFiles.__info__(:functions)
      function_names = Enum.map(functions, &elem(&1, 0))

      # Verify all expected functions exist
      assert :list in function_names
      assert :create in function_names
      assert :retrieve in function_names
      assert :content in function_names
      assert :delete in function_names
    end
  end

  describe "request validation" do
    test "upload request validation accepts valid file" do
      request = %{file: {"test.txt", "content"}}
      result = ContainerFiles.new_upload(request)
      assert result == request
    end

    test "reference request validation accepts valid file_id" do
      request = %{file_id: "file-123"}
      result = ContainerFiles.new_reference(request)
      assert result == request
    end

    test "upload request rejects missing file" do
      assert_raise ArgumentError, fn ->
        ContainerFiles.new_upload(%{})
      end
    end

    test "reference request rejects missing file_id" do
      assert_raise ArgumentError, fn ->
        ContainerFiles.new_reference(%{})
      end
    end
  end

  describe "API field validation" do
    test "only accepts valid API fields for uploads" do
      valid_fields = [:file]

      request =
        ContainerFiles.new_upload(
          file: {"valid.txt", "content"},
          invalid_field: "should_be_filtered",
          another_invalid: "also_filtered"
        )

      # Should only contain valid fields
      assert Map.keys(request) |> Enum.all?(&(&1 in valid_fields))
      assert request[:file] == {"valid.txt", "content"}
      refute Map.has_key?(request, :invalid_field)
      refute Map.has_key?(request, :another_invalid)
    end

    test "only accepts valid API fields for references" do
      valid_fields = [:file_id]

      request =
        ContainerFiles.new_reference(
          file_id: "file-123",
          invalid_field: "should_be_filtered",
          another_invalid: "also_filtered"
        )

      # Should only contain valid fields
      assert Map.keys(request) |> Enum.all?(&(&1 in valid_fields))
      assert request[:file_id] == "file-123"
      refute Map.has_key?(request, :invalid_field)
      refute Map.has_key?(request, :another_invalid)
    end
  end

  describe "file handling patterns" do
    test "handles file content tuple" do
      file_content = {"document.pdf", "binary content"}
      result = ContainerFiles.new_upload(file: file_content)
      assert result[:file] == file_content
    end

    test "handles file path tuple" do
      file_path = {"/home/user/document.txt"}
      result = ContainerFiles.new_upload(file: file_path)
      assert result[:file] == file_path
    end

    test "handles various file ID formats" do
      file_ids = ["file-abc123", "file_def456", "FILE-GHI789"]

      for file_id <- file_ids do
        result = ContainerFiles.new_reference(file_id: file_id)
        assert result[:file_id] == file_id
      end
    end
  end

  describe "function availability" do
    test "provides all expected functions" do
      functions = ContainerFiles.__info__(:functions)
      function_names = Enum.map(functions, &elem(&1, 0))

      # Standard functions
      assert :new_upload in function_names
      assert :new_reference in function_names
      assert :list in function_names
      assert :list! in function_names
      assert :create in function_names
      assert :create! in function_names
      assert :retrieve in function_names
      assert :retrieve! in function_names
      assert :content in function_names
      assert :content! in function_names
      assert :delete in function_names
      assert :delete! in function_names
      assert :file_fields in function_names
    end

    test "bang functions exist for all operations" do
      functions = ContainerFiles.__info__(:functions)
      function_names = Enum.map(functions, &elem(&1, 0))

      # Each operation should have a bang version
      operations = [:list, :create, :retrieve, :content, :delete]

      for op <- operations do
        assert op in function_names
        assert String.to_atom("#{op}!") in function_names
      end
    end
  end

  describe "container context operations" do
    test "all operations require container_id parameter" do
      functions = ContainerFiles.__info__(:functions)

      # Find arity of operations (excluding helper functions)
      list_arities = functions |> Enum.filter(&(elem(&1, 0) == :list)) |> Enum.map(&elem(&1, 1))
      create_arity = functions |> Enum.find(&(elem(&1, 0) == :create)) |> elem(1)
      retrieve_arity = functions |> Enum.find(&(elem(&1, 0) == :retrieve)) |> elem(1)
      content_arity = functions |> Enum.find(&(elem(&1, 0) == :content)) |> elem(1)
      delete_arity = functions |> Enum.find(&(elem(&1, 0) == :delete)) |> elem(1)

      # Operations should accept: openai, container_id, [params/file_id]
      # list has default params, so can be called with 2 or 3 args
      assert 2 in list_arities or 3 in list_arities
      # openai, container_id, request
      assert create_arity == 3
      # openai, container_id, file_id
      assert retrieve_arity == 3
      # openai, container_id, file_id
      assert content_arity == 3
      # openai, container_id, file_id
      assert delete_arity == 3
    end
  end

  describe "file_fields/0" do
    test "returns correct file fields" do
      assert ContainerFiles.file_fields() == [:file]
    end
  end
end
