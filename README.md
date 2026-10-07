# OpenaiEx

[![License: Apache-2](https://img.shields.io/badge/License-Apache2-yellow.svg)](https://opensource.org/license/apache-2-0/)
[![hex.pm badge](https://img.shields.io/hexpm/v/openai_ex.svg)](https://hex.pm/packages/openai_ex)
![hex.pm downloads](https://img.shields.io/hexpm/dw/openai_ex)

A community-maintained Elixir client for the OpenAI API.

- **Mirrors the official [Python SDK](https://github.com/openai/openai-python).** `client.beta.agents.sessions` is `OpenaiEx.Beta.Agents.Sessions`, with the same method names, so OpenAI's own docs translate directly.
- **No application config.** You build a client struct and pass it to every call, which suits Livebook and multi-tenant apps alike.
- **Streaming with cancellation**, over [Finch](https://github.com/sneako/finch).
- **Azure OpenAI and OpenAI-compatible proxies** (local LLMs, gateways) are supported.

## Documentation

The [User Guide](https://hexdocs.pm/openai_ex/userguide.html) is a Livebook with a running example of practically every API call. It is also the test suite, and is run in full before every release.

Further Livebooks on [hexdocs](https://hexdocs.pm/openai_ex):

- [Streaming Orderbot](https://hexdocs.pm/openai_ex/streaming_orderbot.html) and [Deeplearning.AI Orderbot](https://hexdocs.pm/openai_ex/dlai_orderbot.html): chatbots, streaming and not.
- [Image Generation UI](https://hexdocs.pm/openai_ex/images.html): a small Kino app for the GPT image models.

Discussion and release announcements are on the [Elixir Forum thread](https://elixirforum.com/t/openai-ex-openai-api-client-library/55353).

## Contributing

Development runs in a Livebook container. See [AGENTS.md](AGENTS.md) for the setup and the project's conventions.
