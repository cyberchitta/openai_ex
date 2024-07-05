defmodule OpenaiEx.Http.Finch do
  @moduledoc false

  def get!(openai = %OpenaiEx{}, url) do
    build_req(:get, openai, url) |> request!(openai) |> Map.get(:body)
  end

  def delete!(openai = %OpenaiEx{}, url) do
    build_req(:delete, openai, url) |> request!(openai) |> Map.get(:body)
  end

  def post(openai = %OpenaiEx{}, url, multipart: multipart) do
    build_multipart(openai, url, multipart) |> request!(openai) |> Map.get(:body)
  end

  def post(openai = %OpenaiEx{}, url, json: json) do
    build_post(openai, url, json: json) |> request!(openai) |> Map.get(:body)
  end

  def request_options(openai = %OpenaiEx{}) do
    [receive_timeout: openai |> Map.get(:receive_timeout)]
  end

  defp headers(openai = %OpenaiEx{}) do
    openai._http_headers
  end

  def request!(request, openai = %OpenaiEx{}) do
    Finch.request!(request, Map.get(openai, :finch_name), request_options(openai))
  end

  def stream(request, openai = %OpenaiEx{}, fun) do
    Finch.stream(request, Map.get(openai, :finch_name), nil, fun, request_options(openai))
  end

  defp build_req(method, openai = %OpenaiEx{}, url) do
    Finch.build(method, openai.base_url <> url, headers(openai))
  end

  def build_post(openai = %OpenaiEx{}, url, json: json) do
    Finch.build(
      :post,
      openai.base_url <> url,
      headers(openai) ++ [{"Content-Type", "application/json"}],
      Jason.encode_to_iodata!(json)
    )
  end

  def build_multipart(openai = %OpenaiEx{}, url, multipart) do
    Finch.build(
      :post,
      openai.base_url <> url,
      headers(openai) ++
        [
          {"Content-Type", Multipart.content_type(multipart, "multipart/form-data")},
          {"Content-Length", to_string(Multipart.content_length(multipart))}
        ],
      {:stream, Multipart.body_stream(multipart)}
    )
  end
end
