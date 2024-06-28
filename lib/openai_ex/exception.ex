defmodule OpenaiEx.Exception do
  defexception [:type, :message]

  @impl true
  def exception({type, message}) do
    %__MODULE__{type: type, message: to_string(message)}
  end

  @impl true
  def message(%__MODULE__{type: type, message: message}) do
    "OpenaiEx Exception (#{type}): #{message}"
  end
end
