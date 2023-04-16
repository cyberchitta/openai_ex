defmodule OpenaiEx.MixProject do
  use Mix.Project

  @version "0.1.1"
  @description "Community maintained Elixir client for OpenAI API"
  @source_url "https://github.com/restlessronin/openai_ex"

  def project do
    [
      app: :openai_ex,
      version: @version,
      description: @description,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
      preferred_cli_env: [
        docs: :docs,
        "hex.publish": :docs
      ]
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
      {:ex_doc, ">= 0.0.0", only: :docs},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      description: @description,
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      api_reference: false,
      extra_section: "Livebooks",
      extras: [
        "notebooks/readme.livemd"
      ]
    ]
  end
end
