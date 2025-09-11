defmodule OpenaiEx.HttpFinch do
  @moduledoc false
  require Logger
  alias OpenaiEx.Error

  def get(openai = %OpenaiEx{}, url) do
    build_req(:get, openai, url) |> request(openai)
  end

  def delete(openai = %OpenaiEx{}, url) do
    build_req(:delete, openai, url) |> request(openai)
  end

  def post(openai = %OpenaiEx{}, url, multipart: multipart) do
    build_multipart(openai, url, multipart) |> request(openai)
  end

  def post(openai = %OpenaiEx{}, url, json: json) do
    build_post(openai, url, json: json) |> request(openai)
  end

  def request_options(openai = %OpenaiEx{}) do
    [receive_timeout: openai |> Map.get(:receive_timeout)]
  end

  defp headers(openai = %OpenaiEx{}) do
    openai._http_headers
  end

  def stream(request, openai = %OpenaiEx{}, fun) do
    Finch.stream(request, Map.get(openai, :finch_name), nil, fun, request_options(openai))
  end

  def request(request, openai = %OpenaiEx{}) do
    case Finch.request(request, Map.get(openai, :finch_name), request_options(openai)) do
      {:ok, response} -> to_response(response)
      {:error, error} -> to_error(error, request)
    end
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

  defp to_response(%Finch.Response{
         status: status,
         headers: headers,
         body: body,
         trailers: trailers
       })
       when status in 200..299 do
    {:ok, %{status: status, headers: headers, body: body, trailers: trailers}}
  end

  defp to_response(r = %Finch.Response{status: status, body: body})
       when is_integer(status) do
    decoded_body =
      with {:ok, json} <- Jason.decode(body),
           do: json,
           else: ({:error, _} -> %{"error" => %{"message" => "#{inspect(body)}"}})

    {:error, Error.status_error(status, r, decoded_body)}
  end

  def to_error!(error, request) do
    case to_error(error, request) do
      {:error, exception} -> exception
    end
  end

  def to_error(:timeout, request), do: {:error, Error.api_timeout_error(request)}

  def to_error(:closed, request),
    do: {:error, Error.api_connection_error("Connection closed.", request)}

  def to_error(:nxdomain, request),
    do: {:error, Error.api_connection_error("Bad address - Non-Existent Domain.", request)}

  def to_error(%{reason: reason}, request), do: to_error(reason, request)

  def to_error(error, request) when is_exception(error) do
    sanitized = if request, do: sanitize_request(request), else: nil
    Logger.warning("Unhandled Finch exception: #{inspect(error)}, request: #{inspect(sanitized)}")
    {:error, Error.api_connection_error(Exception.message(error), sanitized)}
  end

  def to_error(error, request) do
    sanitized = if request, do: sanitize_request(request), else: nil
    Logger.warning("Unhandled Finch error: #{inspect(error)}, request #{inspect(sanitized)}")
    {:error, Error.api_connection_error(error, sanitized)}
  end

  def sanitize_request(%Finch.Request{headers: headers} = request) when is_list(headers) do
    sanitized_headers =
      Enum.map(headers, fn
        {key, value} when is_binary(key) ->
          if String.downcase(key) == "authorization" and String.starts_with?(value, "Bearer ") do
            {key, "Bearer [REDACTED]"}
          else
            {key, value}
          end

        other ->
          other
      end)

    %{request | headers: sanitized_headers}
  end
end
