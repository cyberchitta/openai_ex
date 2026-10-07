defmodule OpenaiEx.Beta.Agents.Environments do
  @moduledoc """
  This module provides an implementation of the OpenAI agent environments API (beta). The API reference can be found at https://developers.openai.com/api/reference/agents/environments.
  """
  alias OpenaiEx.Http

  defp ep_url(environment_id) do
    "/agents/environments/#{environment_id}"
  end

  def retrieve!(openai = %OpenaiEx{}, environment_id) do
    openai |> retrieve(environment_id) |> Http.bang_it!()
  end

  def retrieve(openai = %OpenaiEx{}, environment_id) do
    openai |> OpenaiEx.with_agents_beta() |> Http.get(ep_url(environment_id))
  end
end
