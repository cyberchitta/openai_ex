# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

> Note: This changelog was retroactively created (by Claude 3.7 Sonnet using the git MCP plugin) in March 2025 and covers versions from 0.8.0 forward.
> Earlier versions do not have detailed change records.

## [0.9.17] - 2025-09-29

### Feat
- added Conversations endpoints (ea82703)

## [0.9.16] - 2025-09-11

### Fix
- fixed error logging on raise (67e12b7)

## [0.9.15] - 2025-09-11

### Feat
- added Evals endpoints (67e1df0)
- added stable VectorStores endpoint (2ce8408)

## [0.9.14] - 2025-08-21

### Feat
- added additional request parameter fields to Responses API (859158d)

## [0.9.13] - 2025-07-16

### BREAKING CHANGE: Stream errors now return OpenaiEx.Error structs instead of raw exceptions

### Feat
- added Containers and ContainerFiles APIs (49ec7c2)

### Refactor
- standardize error handling to return OpenaiEx.Error

### Build
- Updated `finch` from 0.19.0 to 0.20.0

## [0.9.12] - 2025-06-03

### Fix
- fix error masking during streaming (356769b)

## [0.9.11] - 2025-06-03

### Fix
- use api_timeout_error for SSE initial connection timeouts (6ec7d4c)
- updated image edit example with (now required) dummy filenames (6ec7d4c)

## [0.9.10] - 2025-05-15

### Fix
- handle non-JSON payloads in 3XX/4XX responses gracefully (4d7ca49)

## [0.9.9] - 2025-05-15

### Feat
- handle list-formatted errors from Gemini API (e1669f8)

## [0.9.8] - 2025-05-15

### Fixed
- handle non-JSON responses from 5xx errors (895666f)

## [0.9.7] - 2025-04-26

### Added
- update/sort image endpoint params (7fae56c)
- add support for multiple input images (e4f2489)

## [0.9.6] - 2025-04-25

### Fixed
- add new 4o image gen api fields (f2d3d97)

## [0.9.5] - 2025-04-14

### Fixed
- Fixed resolve streaming request hang during timeout (867477a)

## [0.9.4] - 2025-03-26

### Added
- Added retroactive changelog documenting project history since version 0.8.0 (5c0d501)

### Fixed
- Fixed potential race condition in streaming implementation (42aa402)

## [0.9.3] - 2025-03-25

### Fixed
- Cleanup streaming task in error path (6370ff6)
- Clean up streaming tasks to prevent unexpected messages (634f5f5)
- Remove unused task param (81b6812)

## [0.9.2] - 2025-03-21

### Added
- Support for handling array parameters properly in query string generation (b7e9aff)
- Added query parameter to "new" functions (ab38cf2)
- Added 'include' to API fields for response creation (911964d)
- Added list/map query parameter to endpoints (a9aaca6)

### Fixed
- Proper handling of list output (10ab65b)
- Remove extra list construction (eb72366)

### Changed
- Updated source URL (5c2631c)

## [0.9.1] - 2025-03-18

### Added
- CRUD operations for Chat Completions and Responses (b878dbd)

### Fixed
- Flatten query metadata (bbe5719)

## [0.9.0] - 2025-03-12

### Added
- Responses API endpoint (99ecdec)
- Web-search parameter to chat completions (08fbd03)

### Changed
- Updated dependencies (853f562)
- Removed non-executable docs leaving only links to the API reference (57ae9cc)

### Fixed
- Removed redundant alias (9418f81)

## [0.8.6] - 2025-02-06

### Added
- Redact API token in Finch error logs (4499c77)

### Changed
- Updated dependencies (93a6e4e)
- Improved completion documentation (ce95487)

## [0.8.5] - 2024-12-24

### Added
- Support for developer messages (3b6b11e)
- Support for reasoning models (0390d67)

### Changed
- Updated dependencies (bb0d306)

## [0.8.4] - 2024-12-13

### Added
- Store parameter to Chat Completion API call (64741d5)

## [0.8.3] - 2024-10-19

### Added
- Allow arbitrary HTTP headers to be added to requests (7f20ed7)

## [0.8.2] - 2024-10-11

### Added
- Added option to provide an OpenAI project ID (dfda65c)
- Handle :nxdomain errors (fcd591f)

### Changed
- Updated dependencies (487554a)
- Fixed credo warnings (e45b158)

## [0.8.1] - 2024-09-04

### Added
- Restored completions API (e538b8a)
- Restored completions notebook (2d2c1ba)

### Changed
- Updated dependencies

## [0.8.0] - 2024-07-29

### Added
- Logging for unknown errors (80e6f13)

### Fixed
- Added error handler for closed connections (a03bdc1)

### Changed
- Updated dependencies (86df1c4)

## [0.7.0] - 2024-06-30
