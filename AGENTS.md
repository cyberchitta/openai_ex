# AGENTS.md

Notes for anyone (human or agent) changing this library. They cover what the code does not make obvious.

## Conventions

- **The Python SDK is the benchmark.** A resource at `client.x.y` in [openai-python](https://github.com/openai/openai-python) is the module `OpenaiEx.X.Y`, and methods keep the SDK's names (`create`, `retrieve`, `update`, `list`, `delete`, `content`, `stream`). Beta APIs live under `OpenaiEx.Beta.*` and add their `OpenAI-Beta` header via a `with_*_beta` helper in `OpenaiEx`. To find what changed upstream, diff the SDK's `api.md` (paths) and `*_create_params.py` (fields) between two tags.
- **`@api_fields` is the request filter.** Each module `Map.take`s its known fields before sending, so a new upstream param does nothing until it is added here. New enum *values* need no code; they pass straight through.
- **Streaming** is `create(openai, params, stream: true)` and returns `%{body_stream: ..., task_pid: ...}`. Chunks are sent to the process that opened the request, so consume the stream in that process.
- **Multipart is encoded by value shape, not by a per-param table.** `file_fields/0` separates files from text, a list becomes repeated `k[]` fields, and a map becomes `k[sub]` (one level). Query strings are different: they are name-keyed, with lists only for `:include` and maps only for `:metadata`.
- **Never print a credential.** The client struct derives `Inspect` without `token` and `_http_headers`, and `OpenaiEx.Error` redacts `Authorization` and `api-key` on the request it carries. Keep both properties when adding fields or error paths.

## Development environment

There is no host Elixir. Everything runs in the Livebook container from `.devcontainer/`, with the repo mounted at `/data`.

```bash
cp .devcontainer/env .devcontainer/.env          # then fill in the values
cd .devcontainer
docker compose -p openai_ex up -d                  # Livebook on http://localhost:8080
docker compose -p openai_ex exec -w /data livebook mix test
```

- Always pass `-p openai_ex`; without it compose starts a second container.
- **Do not use VS Code's "Reopen in Container".** It replaces the image's entrypoint, so Livebook never starts.
- **The image sets the Elixir/OTP toolchain.** The image version and the notebooks' `kino` pin move together. After changing the image, delete `_build`.
- **Livebook prefixes secrets with `LB_`.** Notebooks read `LB_OPENAI_API_KEY`, while the container itself has `OPENAI_API_KEY`.
- **Livebook owns an open notebook.** It autosaves its in-memory copy over the file, so close a notebook in the UI before editing it on disk.
- **`assets/` is append-only.** Notebooks fetch sample files from `main`, and the hexdocs of every past release link there too.

## The user guide is the test suite

`notebooks/userguide.livemd` exercises practically every endpoint against the live API, and a release needs a full pass. Run it headless:

```bash
docker compose -p openai_ex exec -w /data livebook \
  sh -c 'LB_OPENAI_API_KEY="$OPENAI_API_KEY" elixir scripts/run_notebook.exs notebooks/userguide.livemd'
```

The runner keeps one session in notebook order, skips `force_markdown` cells, and retries a failing cell twice, because some reads lag the write before them. A compile error is never a timing problem: it means an earlier cell failed.

Livebook has no headless runner of its own. The third-party ones (`livebook_test`, LivebookTools) convert the notebook to a single script, which stops at the first error. A few user-guide cells reliably fail once on timing, so those tools would rarely get through a full run. That is why this script exists.

- **The guide deletes everything it creates.** `notebooks/cleanup.livemd` sweeps every resource type in the key's project. It deletes *everything*, so use a test project only. Run it after the guide; anything it finds is a leak.
- **Model choice:** each cell uses the oldest model that works for its feature today and has no announced shutdown. Check `/v1/models` and OpenAI's deprecations page before changing one.

## Releasing

1. Bring the Livebook image and `kino` current.
2. Run the full user guide, then `cleanup.livemd`.
3. Bump `@version` in `mix.exs`.
4. Add a `CHANGELOG.md` entry, with commit hashes as in earlier entries.
5. Update the `{:openai_ex, "~> x.y.z"}` pins in the notebooks and `.github/ISSUE_TEMPLATE/bug_report.yml`.
6. Publish to hex (from inside the container).
7. Push.

The notebooks ship in the hexdocs, so their pins must name the new version at publish time. Nothing is pushed until the package is on hex.

Commits use conventional-commit subjects (`feat:`, `fix:`, `docs:`, `chore:`; `feat!:` for breaking changes).
