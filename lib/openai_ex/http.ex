defmodule OpenaiEx.Http do
  @moduledoc false
  alias OpenaiEx.HttpFinch

  def post(openai = %OpenaiEx{}, url) do
    post(openai, url, json: %{})
  end

  def post(openai = %OpenaiEx{}, url, multipart: multipart) do
    HttpFinch.post(openai, url, multipart: multipart) |> handle_response()
  end

  def post(openai = %OpenaiEx{}, url, json: json) do
    HttpFinch.post(openai, url, json: json) |> handle_response()
  end

  def post_no_decode(openai = %OpenaiEx{}, url, json: json) do
    HttpFinch.post(openai, url, json: json) |> extract_body()
  end

  def get(openai = %OpenaiEx{}, base_url, params) do
    url = build_url(base_url, params)
    openai |> get(url)
  end

  def get(openai = %OpenaiEx{}, url) do
    HttpFinch.get(openai, url) |> handle_response()
  end

  def get_no_decode(openai = %OpenaiEx{}, url) do
    HttpFinch.get(openai, url) |> extract_body()
  end

  def delete(openai = %OpenaiEx{}, url) do
    HttpFinch.delete(openai, url) |> handle_response()
  end

  def to_multi_part_form_data(req, file_fields) do
    mp =
      req
      |> Map.drop(file_fields)
      |> Enum.reduce(Multipart.new(), fn {k, v}, acc ->
        acc |> Multipart.add_part(Multipart.Part.text_field(v, k))
      end)

    req
    |> Map.take(file_fields)
    |> Enum.reduce(mp, fn {k, v}, acc ->
      case v do
        list when is_list(list) ->
          Enum.reduce(list, acc, fn item, inner_acc ->
            inner_acc |> Multipart.add_part(to_file_field_part("#{k}[]", item))
          end)

        _ ->
          acc |> Multipart.add_part(to_file_field_part(k, v))
      end
    end)
  end

  defp to_file_field_part(k, v) do
    case v do
      {path} ->
        Multipart.Part.file_field(path, k)

      {filename, content} ->
        Multipart.Part.file_content_field(filename, content, k, filename: filename)

      content ->
        Multipart.Part.file_content_field("", content, k, filename: "")
    end
  end

  def build_url(base_url, params \\ %{}) do
    prepared_params = prepare_query_params(params)

    if Enum.empty?(prepared_params) do
      base_url
    else
      base_url
      |> URI.new!()
      |> URI.append_query(prepared_params |> URI.encode_query())
      |> URI.to_string()
    end
  end

  def prepare_query_params(params) when is_map(params) do
    Enum.flat_map(params, fn
      {key, values} when is_map(values) and key in [:metadata] ->
        Enum.map(values, fn {k, v} -> {"#{key}[#{k}]", v} end)

      {key, values} when is_list(values) and key in [:include] ->
        Enum.map(values, fn v -> {"#{key}[]", v} end)

      {key, value} ->
        [{key, value}]
    end)
  end

  defp handle_response(response) do
    response |> extract_body() |> jsonify()
  end

  defp extract_body(response) do
    case response do
      {:ok, response} -> {:ok, response.body}
      _ -> response
    end
  end

  defp jsonify(response) do
    case response do
      {:ok, response} -> {:ok, Jason.decode!(response)}
      _ -> response
    end
  end

  def bang_it!(response) do
    case response do
      {:ok, response} -> response
      {:error, error} -> raise error
    end
  end
end
