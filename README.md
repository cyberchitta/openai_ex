# README

`OpenaiEx` is an Elixir library that provides a community-maintained client for the OpenAI API. The library closely follows the structure of the [official OpenAI API client libraries](https://platform.openai.com/docs/api-reference) for [Python](https://github.com/openai/openai-python) and [JavaScript](https://github.com/openai/openai-node), making it easy to understand and reuse existing documentation and code.

## Installation and Usage

For detailed installation instructions and usage examples, please open the [Usage Guide Livebook](./notebooks/readme.livemd).

## Development

This library was developed inside a Livebook docker image running in a VS Code devcontainer (check out the `.devcontainer` folder for details).

Clone the repo to your local machine, open it in VS Code, and follow the prompts to open in container.

Once the container is running in VS Code, you can open livebook at http://localhost:8080. You will need to enter the password that is in the secret environment variable `LIVEBOOK_PASSWORD` (set in `.env`, explained below).

### Env vars and secrets

For devcontainer development, any secrets (such as `OPENAI_API_KEY`) are defined as environment variables in a `.env` file in the `.devcontainer` folder. This file should **not be placed** in version control (and is included in `.gitignore` for that reason). A sample `env` (without the '.') is provided which can form the basis for your `.env` file. These secrets are passed through to Livebook in `docker-compose.yml`.