defmodule OpenaiEx.MsgContent do
  @moduledoc false

  @doc """
  Create text content.

  Example usage:

      iex> _message = OpenaiEx.MsgContent.text("Hello, world!")
      %{text: "Hello, world!", type: "text"}
  """
  def text(content), do: %{type: "text", text: content}

  @doc """
  Create image content (from file_id)

  Example usage:

      iex> _message = OpenaiEx.MsgContent.image_file("file-BK7bzQj3FfZFXr7DbL6xJwfo")
      %{image_file: %{file_id: "file-BK7bzQj3FfZFXr7DbL6xJwfo"}, type: "image_file"}
  """
  def image_file(file_id), do: %{type: "image_file", image_file: %{file_id: file_id}}

  @doc """
  Create image content (from url)

  Example usage:

      iex> _message = OpenaiEx.MsgContent.image_url("https://upload.wikimedia.org/fake_image_path.jpg")
      %{image_url: "https://upload.wikimedia.org/fake_image_path.jpg", type: "image_url"}
  """
  def image_url(url), do: %{type: "image_url", image_url: url}
end
