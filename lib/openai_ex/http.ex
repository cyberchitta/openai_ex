defmodule OpenaiEx.Http do
  @moduledoc false

  def headers(openai = %OpenaiEx{}) do
    openai._http_headers
  end

  def request_options(openai = %OpenaiEx{}) do
    [receive_timeout: openai |> Map.get(:receive_timeout)]
  end

  def build_finch(method, openai = %OpenaiEx{}, url) do
    Finch.build(method, openai.base_url <> url, headers(openai))
  end

  def post(openai = %OpenaiEx{}, url) do
    post(openai, url, json: %{})
  end

  def post(openai = %OpenaiEx{}, url, multipart: multipart) do
    :post
    |> Finch.build(
      openai.base_url <> url,
      headers(openai) ++
        [
          {"Content-Type", Multipart.content_type(multipart, "multipart/form-data")},
          {"Content-Length", to_string(Multipart.content_length(multipart))}
        ],
      {:stream, Multipart.body_stream(multipart)}
    )
    |> finch_run(openai)
  end

  def post(openai = %OpenaiEx{}, url, json: json) do
    build_post(openai, url, json: json)
    |> finch_run(openai)
  end

  def post_no_decode(openai = %OpenaiEx{}, url, json: json) do
    build_post(openai, url, json: json)
    |> finch_run_no_decode(openai)
  end

  def build_post(openai = %OpenaiEx{}, url, json: json) do
    :post
    |> Finch.build(
      openai.base_url <> url,
      headers(openai) ++ [{"Content-Type", "application/json"}],
      Jason.encode_to_iodata!(json)
    )
  end

  def get(openai = %OpenaiEx{}, base_url, params) do
    query =
      base_url
      |> URI.new!()
      |> URI.append_query(params |> URI.encode_query())
      |> URI.to_string()

    openai |> get(query)
  end

  def get(openai = %OpenaiEx{}, url) do
    :get |> build_finch(openai, url) |> finch_run(openai)
  end

  def get_no_decode(openai = %OpenaiEx{}, url) do
    :get |> build_finch(openai, url) |> finch_run_no_decode(openai)
  end

  def delete(openai = %OpenaiEx{}, url) do
    :delete |> build_finch(openai, url) |> finch_run(openai)
  end

  def finch_run(finch_request, openai = %OpenaiEx{}) do
    finch_request |> finch_run_no_decode(openai) |> Jason.decode!()
  end

  def finch_run_no_decode(finch_request, openai = %OpenaiEx{}) do
    finch_request
    |> Finch.request!(Map.get(openai, :finch_name), request_options(openai))
    |> Map.get(:body)
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
      acc |> Multipart.add_part(to_file_field_part(k, v))
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
end
