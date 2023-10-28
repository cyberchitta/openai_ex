defmodule OpenaiEx.MixProject do
  use Mix.Project

  @version "0.3.0"
  @description "Community maintained OpenAI API Elixir client for Livebook"
  @source_url "https://github.com/restlessronin/openai_ex"

  def project do
    [
      app: :openai_ex,
      version: @version,
      description: @description,
      elixir: "~> 1.12",
      elixirc_options: [debug_info: true],
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
      mod: {OpenaiEx.Application, []}
    ]
  end

  defp deps do
    [
      {:finch, "~> 0.16"},
      {:jason, "~> 1.4"},
      {:multipart, "~> 0.4"},
      {:ex_doc, ">= 0.0.0", only: :docs},
      {:credo, "~> 1.6", only: :dev, runtime: false}
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
      main: "userguide",
      source_url: @source_url,
      source_ref: "v#{@version}",
      api_reference: false,
      extra_section: "Livebooks",
      extras: [
        "notebooks/userguide.livemd",
        "notebooks/streaming_orderbot.livemd",
        "notebooks/dlai_orderbot.livemd",
        "notebooks/completions.livemd",
        "notebooks/images.livemd"
      ]
    ]
  end
end
