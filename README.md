# README

[![License: Apache-2](https://img.shields.io/badge/License-Apache2-yellow.svg)](https://opensource.org/license/apache-2-0/)
[![hex.pm badge](https://img.shields.io/hexpm/v/openai_ex.svg)](https://hex.pm/packages/openai_ex)
![hex.pm downloads](https://img.shields.io/hexpm/dw/openai_ex)

`OpenaiEx` is an Elixir library that provides a battle-tested, community-maintained OpenAI API client.

The main user guide is a livebook, so you should be able to run everything without any setup. The user guide is also the test suite. It is run before every version release, so it is always up to date with the library.

> Portions of this project were developed with assistance from ChatGPT 3.5 and 4, as well as Claude 3 Opus and Claude Sonnets 3.5, 3.6 and 3.7. However, every line of code is human curated (by me, @restlessronin 😇). AI collaboration facilitated by [llm-context](https://github.com/cyberchitta/llm-context.py).

## Features and Benefits

All API endpoints and features (as of Mar 16, 2025) are supported, including the most recent Responses API (proposed replacement for Chat Completion). The Containers and ContainerFiles APIs have also been added.

### Battle-Tested and Production-Ready

This library has evolved significantly based on real-world usage and community contributions:

- **Enhanced Reliability**: Includes specific improvements from production use cases such as:
  - API key redaction in logs to prevent credential leakage
  - Proper handling of SSE (Server-Sent Events) edge cases
  - Configurable timeouts and connection parameters
  - Support for non-standard SSE implementations in some LLM providers
- **Broad Compatibility**: Support for Azure OpenAI, local LLMs via OpenAI-compatible proxies, and third-party integrations like Portkey

## Key Design Choices

There are some important differences compared to other Elixir OpenAI wrappers:

- **Python API Alignment**: Faithful mirroring of the [official Python API](https://github.com/openai/openai-python) structure. Content in memory can be uploaded directly without reading from files.

- **Livebook-First Design**: Designed with Livebook compatibility in mind, relying on direct instantiation rather than application configuration.

- **Finch-Based Transport**: Uses Finch for HTTP requests, which provides more control over connection pools and is well-suited for modern Elixir applications.

- **Streaming Support**: Comprehensive streaming API implementations with request cancellation capabilities.

- **Flexible Deployment**: 3rd Party (including local) LLMs with an OpenAI proxy, as well as the **Azure OpenAI API**, are considered legitimate use cases.

Discussion and announcements are on [this thread in Elixir Forum](https://elixirforum.com/t/openai-ex-openai-api-client-library/)

## Installation and Usage

For installation instructions and detailed usage examples, please look at the [User Guide on hexdocs](https://hexdocs.pm/openai_ex/userguide.html). The guide is a Livebook, and you can run all of the code in it without creating a new project. Practically every API call has a running example in the User Guide.

There are also Livebook examples for:

- [Streaming Orderbot](https://hexdocs.pm/openai_ex/streaming_orderbot.html) - An example of how to use ChatCompletion streaming in a Chatbot. This is a streaming version of the next Livebook in this list.
- [Deeplearning.AI Orderbot](https://hexdocs.pm/openai_ex/dlai_orderbot.html) - This notebook is an elixir / Kino translation of the python notebook in [Lesson 8](https://learn.deeplearning.ai/chatgpt-prompt-eng/lesson/8/chatbot), of [Deeplearning.AI](https://www.deeplearning.ai/)'s course [ChatGPT Prompt Engineering for Developers](https://www.deeplearning.ai/short-courses/chatgpt-prompt-engineering-for-developers/).
- [Completions Chatbot](https://hexdocs.pm/openai_ex/completions.html) - Can be deployed as a Livebook app. The deployed app displays 2 forms, one for normal completions and another for streaming completions.
- [Image Generation UI](https://hexdocs.pm/openai_ex/images.html) - A simple interface for generating images with DALL-E.

These are hosted on [hexdocs](https://hexdocs.pm/openai_ex) and can be used as inspiration / starters for your own projects.

## Development

The following section is only for developers that want to contribute to this repository.

This library was developed using a Livebook docker image that runs inside a VS Code devcontainer. The `.devcontainer` folder contains all of the relevant files.

To get started, clone the repository to your local machine and open it in VS Code. Follow the prompts to open it in a container.

After the container is up and running in VS Code, you can access livebook at http://localhost:8080. However, you'll need to enter a password that's stored in the environment variable `LIVEBOOK_PASSWORD`. This variable needs to be defined in the `.devcontainer/.env` file, which is explained below.

### Environment Variables and Secrets

To set environment variables for devcontainer development, you can create a `.env` file in the `.devcontainer` folder. Any secrets, such as `OPENAI_API_KEY` and `LIVEBOOK_PASSWORD`, can be defined in this file as environment variables. Note that this `.env` file should not be included in version control, and it is already included in the .gitignore file for this reason.

You can find a sample `env` file in the same folder, which you can use as a template for your own `.env` file. These variables will be passed to Livebook via `docker-compose.yml`.
