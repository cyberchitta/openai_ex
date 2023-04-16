# README

`OpenaiEx` is an Elixir library that provides a community-maintained client for the OpenAI API.

The library closely follows the structure of the [official OpenAI API client libraries](https://platform.openai.com/docs/api-reference) for [Python](https://github.com/openai/openai-python) and [JavaScript](https://github.com/openai/openai-node), making it easy to understand and reuse existing documentation and code.

## Installation and Usage

For installation instructions and detailed usage examples, please see the [User Guide Livebook](./notebooks/userguide.livemd).

## Development

The following section is only for developers that want to contribute to this repository.

This library was developed using a Livebook docker image that runs inside a VS Code devcontainer. The `.devcontainer` folder contains all the relevant files.

To get started, clone the repository to your local machine and open it in VS Code. Follow the prompts to open it in a container.

After the container is up and running in VS Code, you can access livebook at http://localhost:8080. However, you'll need to enter a password that's stored in the environment variable `LIVEBOOK_PASSWORD`. You can find this variable in the `.env` file, which is explained below.

### Environment Variables and Secrets

To set environment variables for devcontainer development, you can create a `.env` file in the `.devcontainer` folder. Any secrets, such as `OPENAI_API_KEY` and `LIVEBOOK_PASSWORD`, can be defined in this file as environment variables. Note that the .env file should not be included in version control, and it's already included in the .gitignore file for this reason.

You can find a sample `env` file in the same folder, which you can use as a template for your own `.env` file. These secrets will be passed to Livebook through `docker-compose.yml`.