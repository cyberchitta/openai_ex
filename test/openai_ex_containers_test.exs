defmodule OpenaiExContainersTest do
  use ExUnit.Case
  doctest OpenaiEx.Containers

  alias OpenaiEx.Containers

  describe "new/1" do
    test "creates request with name only" do
      result = Containers.new(name: "Test Container")
      assert result == %{name: "Test Container"}
    end

    test "creates request with all fields" do
      result =
        Containers.new(
          name: "Full Container",
          expires_after: %{anchor: "last_active_at", minutes: 30},
          file_ids: ["file-123", "file-456"]
        )

      expected = %{
        name: "Full Container",
        expires_after: %{anchor: "last_active_at", minutes: 30},
        file_ids: ["file-123", "file-456"]
      }

      assert result == expected
    end

    test "creates request from map" do
      result =
        Containers.new(%{
          name: "Map Container",
          expires_after: %{anchor: "last_active_at", minutes: 10}
        })

      assert result == %{
               name: "Map Container",
               expires_after: %{anchor: "last_active_at", minutes: 10}
             }
    end

    test "filters out invalid fields" do
      result =
        Containers.new(
          name: "Clean Container",
          invalid_field: "should_be_removed",
          expires_after: %{anchor: "last_active_at", minutes: 15}
        )

      expected = %{
        name: "Clean Container",
        expires_after: %{anchor: "last_active_at", minutes: 15}
      }

      assert result == expected
    end
  end

  describe "endpoint URLs" do
    test "module has correct structure" do
      # Since ep_url is private, we test the module structure instead
      functions = Containers.__info__(:functions)
      function_names = Enum.map(functions, &elem(&1, 0))

      # The module should have all expected public functions
      assert :new in function_names
      assert :list in function_names
      assert :create in function_names
      assert :retrieve in function_names
      assert :delete in function_names
    end
  end

  describe "API field validation" do
    test "only accepts valid API fields" do
      valid_fields = [:name, :expires_after, :file_ids, :container_id]

      request =
        Containers.new(
          name: "Valid Container",
          expires_after: %{anchor: "last_active_at", minutes: 20},
          file_ids: ["file-1"],
          container_id: "cntr_123",
          invalid_field: "should_be_filtered"
        )

      # Should only contain valid fields
      assert Map.keys(request) |> Enum.all?(&(&1 in valid_fields))
      assert request[:name] == "Valid Container"
      assert request[:expires_after] == %{anchor: "last_active_at", minutes: 20}
      assert request[:file_ids] == ["file-1"]
      assert request[:container_id] == "cntr_123"
      refute Map.has_key?(request, :invalid_field)
    end
  end

  describe "parameter validation" do
    test "handles empty parameters" do
      result = Containers.new(%{})
      assert result == %{}
    end

    test "handles list conversion" do
      result = Containers.new(name: "List Container")
      assert result == %{name: "List Container"}
    end

    test "handles complex expires_after structure" do
      expires_config = %{
        anchor: "last_active_at",
        minutes: 60
      }

      result =
        Containers.new(
          name: "Expiring Container",
          expires_after: expires_config
        )

      assert result[:expires_after] == expires_config
    end

    test "handles file_ids as list" do
      file_ids = ["file-abc123", "file-def456", "file-ghi789"]

      result =
        Containers.new(
          name: "Multi-file Container",
          file_ids: file_ids
        )

      assert result[:file_ids] == file_ids
    end
  end

  describe "function availability" do
    test "provides all expected functions" do
      functions = Containers.__info__(:functions)
      function_names = Enum.map(functions, &elem(&1, 0))

      # Standard functions
      assert :new in function_names
      assert :list in function_names
      assert :list! in function_names
      assert :create in function_names
      assert :create! in function_names
      assert :retrieve in function_names
      assert :retrieve! in function_names
      assert :delete in function_names
      assert :delete! in function_names
    end

    test "bang functions exist for all operations" do
      functions = Containers.__info__(:functions)
      function_names = Enum.map(functions, &elem(&1, 0))

      # Each operation should have a bang version
      operations = [:list, :create, :retrieve, :delete]

      for op <- operations do
        assert op in function_names
        assert String.to_atom("#{op}!") in function_names
      end
    end
  end
end
