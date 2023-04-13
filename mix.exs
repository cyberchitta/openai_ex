defmodule OpenaiEx.MixProject do
  use Mix.Project

  @version "0.0.1"
  @description "Community maintained Elixir client for OpenAI API"
  @source_url "https://github.com/restlessronin/openai_ex"

  def project do
    [
      app: :openai_ex,
      version: @version,
      description: @description,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.3"},
      {:ex_doc, ">= 0.0.0", only: :docs}
    ]
  end
end
