# OpenaiEx

Community maintained Elixir client for OpenAI API.

By design the `OpenaiEx` api maps closely to the [official OpenAI API client libraries](https://platform.openai.com/docs/api-reference) in python and JS. This simplifies our doc job, since we simply point at the original references, instead of duplicating them.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `openai_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:openai_ex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/openai_ex>.

## Usage


## Development

This library was developed inside a Livebook docker image running in a VS Code devcontainer (check out the `.devcontainer` folder for details).

Clone the repo to your local machine, open it in VS Code, and follow the prompts to open in container.

Once the container is running in VS Code, you can open livebook [here](http://localhost:8080). You will need to enter the password that is in the secret environment variable `LIVEBOOK_PASSWORD` (set in `.env`, explained below).

### Env vars and secrets

For devcontainer development, any secrets (such as `OPENAI_API_KEY`) are defined as environment variables in a `.env` file in the `.devcontainer` folder. This file should **not be placed** in version control (and is included in `.gitignore` for that reason). A sample `env` (without the '.') is provided which can form the basis for your `.env` file. These secrets are passed through to Livebook in `docker-compose.yml`.