defmodule OpenaiEx.Exception do
  defexception [:type, :message, :http_status, :error_code]

  def new({type, message}) do
    exception({type, message, nil, nil})
  end

  def new({type, message, http_status}) do
    exception({type, message, http_status, nil})
  end

  def new({type, message, http_status, error_code}) do
    exception({type, message, http_status, error_code})
  end

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
    "OpenaiEx Exception (#{type}): #{message}" <>
      if(http_status, do: " (HTTP #{http_status})", else: "") <>
      if(error_code, do: " (Error Code: #{error_code})", else: "")
  end
end
