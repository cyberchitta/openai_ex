defmodule OpenaiEx.MixProject do
  use Mix.Project

  @version "0.0.1"
  @source_url "https://github.com/restlessronin/openai_ex"

  def project do
    [
      app: :openai_ex,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.3"},
      {:ex_doc, ">= 0.0.0", only: :docs}
    ]
  end
end
