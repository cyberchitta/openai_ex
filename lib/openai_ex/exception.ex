defmodule OpenaiEx.Exception do
  defexception [:type, :message, :http_status, :error_code]

  @impl true
  def exception({type, message, http_status, error_code}) do
    %__MODULE__{
      type: type,
      message: to_string(message),
      http_status: http_status,
      error_code: error_code
    }
  end

  @impl true
  def message(%__MODULE__{
        type: type,
        message: message,
        http_status: http_status,
        error_code: error_code
      }) do
    "OpenaiEx Exception (#{type}): #{message} (HTTP #{http_status}, Error Code: #{error_code})"
  end
end
