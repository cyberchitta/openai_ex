defmodule OpenaiEx.Error do
  defexception [:message, :request, :body, :code, :param, :type, :status_code, :request_id, :name]

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
    type = attrs[:type] || :api_error
    name = @error_names[type]
    error = struct!(__MODULE__, [name: name] ++ attrs)

    if is_map(error.body) do
      %{
        error
        | code: error.body["code"],
          param: error.body["param"],
          type_details: error.body["type"]
      }
    else
      error
    end
  end

  @impl true
  def message(%__MODULE__{} = error) do
    "#{error.name}: #{error.message}" <>
      if(error.status_code, do: " (HTTP #{error.status_code})", else: "")
  end

  def open_ai_error(message) do
    exception(type: :open_ai_error, message: message)
  end

  def api_error(message, request, body) do
    exception(type: :api_error, message: message, request: request, body: body)
  end

  def api_response_validation_error(response, body, message \\ nil) do
    exception(
      type: :api_response_validation_error,
      message: message || "Data returned by API invalid for expected schema.",
      response: response,
      body: body,
      status_code: response.status
    )
  end

  def api_status_error(message, response, body) do
    exception(
      type: :api_status_error,
      message: message,
      response: response,
      body: body,
      status_code: response.status,
      request_id: get_in(response, [:headers, "x-request-id"])
    )
  end

  def api_connection_error(message \\ "Connection error.", request) do
    exception(type: :api_connection_error, message: message, request: request)
  end

  def api_timeout_error(request) do
    exception(type: :api_timeout_error, message: "Request timed out.", request: request)
  end

  def status_error(status_code, message, response, body) when status_code in 400..499,
    do: status_error(@status_code_map[status_code], status_code, message, response, body)

  def status_error(status_code, message, response, body) when status_code in 500..599,
    do: status_error(:internal_server_error, 500, message, response, body)

  defp status_error(type, status_code, message, response, body) do
    exception(
      type: type,
      message: message,
      response: response,
      body: body,
      status_code: status_code,
      request_id: get_in(response, [:headers, "x-request-id"])
    )
  end

  def sse_timeout_error() do
    exception(type: :sse_timeout_error, message: "SSE next chunk timed out.")
  end

  def sse_user_cancellation() do
    exception(type: :sse_cancellation, message: "SSE user canceled.")
  end
end
