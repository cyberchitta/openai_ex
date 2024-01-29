# README
[![License: Apache-2](https://img.shields.io/badge/License-Apache2-yellow.svg)](https://opensource.org/license/apache-2-0/)
[![hex.pm badge](https://img.shields.io/hexpm/v/openai_ex.svg)](https://hex.pm/packages/openai_ex)

`OpenaiEx` is an Elixir library that provides a community-maintained OpenAI API client especially for Livebook development.

Portions of this project were developed with assistance from ChatGPT 3.5 and 4. However, every line of code is human curated (by me 😇).

All API endpoints and features (as of Nov 15, 2023) are supported, including the **Assistants API Beta**, DALL-E-3, Text-To-Speech, the **tools support** in chat completions, and the **streaming version** of the chat completion endpoint. Streaming request **cancellation** is also supported.

Configuration of Finch pools and API base url are supported.

There are some differences compared to other elixir openai wrappers.

* I tried to faithfully mirror the naming/structure of the [official python api](https://github.com/openai/openai-python). For example, content that is already in memory can be uploaded as part of a request, it doesn't have to be read from a file at a local path.
* I was developing for a livebook use-case, so I don't have any config, only environment variables.
* Streaming API versions, with request cancellation, are supported.
* The underlying transport is finch, rather than httpoison
* 3rd Party (including local) LLMs with an OpenAI proxy are on the radar as a legitimate use case

Discussion and announcements are on [this thread in Elixir Forum](https://elixirforum.com/t/openai-ex-openai-api-client-library/)

## Installation and Usage

For installation instructions and detailed usage examples, please look at the [User Guide on hexdocs](https://hexdocs.pm/openai_ex/userguide.html). The guide is a Livebook, and you can run all of the code in it without creating a new project. Practically every API call has a running example in the User Guide.

There are also Livebook examples for
* [Streaming Orderbot](https://hexdocs.pm/openai_ex/streaming_orderbot.html) An example of how to use ChatCompletion streaming in a Chatbot. This is a streaming version of the next Livebook in this list.
* The [Deeplearning.AI Orderbot](https://hexdocs.pm/openai_ex/dlai_orderbot.html). This notebook is an elixir / Kino translation of the python notebook in [Lesson 8](https://learn.deeplearning.ai/chatgpt-prompt-eng/lesson/8/chatbot), of [Deeplearning.AI](https://www.deeplearning.ai/)'s course [ChatGPT Prompt Engineering for Developers](https://www.deeplearning.ai/short-courses/chatgpt-prompt-engineering-for-developers/).
* A [Completions Chatbot](https://hexdocs.pm/openai_ex/completions.html) which can be deployed as a Livebook app. The deployed app displays 2 forms, one for normal completions and another for streaming completions.
* An [Image Generation UI](https://hexdocs.pm/openai_ex/images.html)

These are hosted on [hexdocs](https://hexdocs.pm/openai_ex) and can be used as inspiration / starters for your own projects.

## Development

The following section is only for developers that want to contribute to this repository.

This library was developed using a Livebook docker image that runs inside a VS Code devcontainer. The `.devcontainer` folder contains all of the relevant files.

To get started, clone the repository to your local machine and open it in VS Code. Follow the prompts to open it in a container.

After the container is up and running in VS Code, you can access livebook at http://localhost:8080. However, you'll need to enter a password that's stored in the environment variable `LIVEBOOK_PASSWORD`. This variable needs to be defined in the `.devcontainer/.env` file, which is explained below.

### Environment Variables and Secrets

To set environment variables for devcontainer development, you can create a `.env` file in the `.devcontainer` folder. Any secrets, such as `OPENAI_API_KEY` and `LIVEBOOK_PASSWORD`, can be defined in this file as environment variables. Note that this `.env` file should not be included in version control, and it is already included in the .gitignore file for this reason.

You can find a sample `env` file in the same folder, which you can use as a template for your own `.env` file. These variables will be passed to Livebook via `docker-compose.yml`.
