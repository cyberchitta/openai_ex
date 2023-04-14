defmodule OpenaiEx do
  defstruct organization: nil, token: nil

  def new(
        organization \\ System.fetch_env!("OPENAI_ORGANIZATION"),
        token \\ System.get_env("OPENAI_API_KEY", "")
      ) do
    %OpenaiEx{
      organization: organization,
      token: token
    }
  end

end
