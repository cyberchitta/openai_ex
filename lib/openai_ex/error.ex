defmodule OpenaiEx.Error do
  defexception [
    :status_code,
    :name,
    :message,
    :body,
    :code,
    :param,
    :type,
    :request_id,
    :request,
    :kind
  ]

  @error_names %{
    bad_request: "BadRequestError",
    authentication: "AuthenticationError",
    permission_denied: "PermissionDeniedError",
    not_found: "NotFoundError",
    conflict: "ConflictError",
    unprocessable_entity: "UnprocessableEntityError",
    rate_limit: "RateLimitError",
    internal_server: "InternalServerError",
    api_response_validation: "APIResponseValidationError",
    api_connection: "APIConnectionError",
    api_timeout: "APITimeoutError",
    api_error: "APIError"
  }

  @status_code_map %{
    400 => :bad_request,
    401 => :authentication,
    403 => :permission_denied,
    404 => :not_found,
    409 => :conflict,
    422 => :unprocessable_entity,
    429 => :rate_limit
  }

  @impl true
  def exception(attrs) when is_list(attrs) do
    kind = attrs[:kind] || :api_error
    name = @error_names[kind]
    error = struct(__MODULE__, [name: name] ++ attrs)

    if is_map(error.body) do
      %{
        error
        | code: error.body["code"],
          param: error.body["param"],
          type: error.body["type"]
      }
    else
      error
    end
  end

  @impl true
  def message(error = %__MODULE__{}) do
    "#{error.name}: #{error.message}" <>
      if(error.status_code, do: " (HTTP #{error.status_code})", else: "") <>
      if(error.body, do: " (JSON #{inspect(error.body)})", else: "")
  end

  def open_ai_error(message) do
    exception(kind: :open_ai_error, message: message)
  end

  def api_error(message, request, body) do
    exception(kind: :api_error, message: message, request: request, body: body)
  end

  def api_response_validation_error(response, body, message \\ nil) do
    exception(
      kind: :api_response_validation_error,
      message: message || "Data returned by API invalid for expected schema.",
      response: response,
      body: body,
      status_code: response.status
    )
  end

  def api_status_error(message, response, body) do
    exception(
      kind: :api_status_error,
      message: message,
      response: response,
      body: body,
      status_code: response.status,
      request_id: get_in(response, [:headers, "x-request-id"])
    )
  end

  def api_connection_error(message, request) do
    exception(kind: :api_connection_error, message: message, request: request)
  end

  def api_timeout_error(request) do
    exception(kind: :api_timeout_error, message: "Request timed out.", request: request)
  end

  def status_error(status_code, response, body) when status_code in 400..499,
    do: status_error(@status_code_map[status_code], status_code, response, body)

  def status_error(status_code, response, body) when status_code in 500..599,
    do: status_error(:internal_server_error, 500, response, body)

  defp status_error(kind, status_code, response, body) when is_list(body) and length(body) > 0 do
    status_error(kind, status_code, response, List.first(body))
  end

  defp status_error(kind, status_code, response, body) when is_map(body) do
    error = body["error"]

    exception(
      kind: kind,
      message: error["message"],
      response: response,
      body: error,
      status_code: status_code,
      request_id: get_in(response.headers, [Access.filter(&(elem(&1, 0) == "x-request-id")), Access.elem(1)])
    )
  end

  def sse_timeout_error() do
    exception(kind: :sse_timeout_error, message: "SSE next chunk timed out.")
  end

  def sse_user_cancellation() do
    exception(kind: :sse_cancellation, message: "SSE user canceled.")
  end
end
