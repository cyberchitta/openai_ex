defmodule OpenaiEx do
  @enforce_keys [:token]
  defstruct token: nil, organization: nil

  def new(token, organization \\ nil) do
    %OpenaiEx{
      token: token,
      organization: organization
    }
  end

  def req(openai = %OpenaiEx{}) do
    options = [base_url: "https://api.openai.com/v1", auth: {:bearer, openai.token}]

    if is_nil(openai.organization) do
      options
    else
      options ++ [headers: ["OpenAI-Organization", openai.organization]]
    end
    |> Req.new()
  end
end
