# Bormashino Architecture & Developer Guide

## Project Overview
Bormashino is a framework for building Single Page Applications (SPAs) using Ruby. It leverages `ruby.wasm` to run a Ruby runtime directly in the browser, allowing developers to write their application logic in Ruby (using Sinatra) while interacting with the DOM and browser APIs.

## Directory Structure
- **`gem/`**: The core Ruby gem (`bormashino`). Contains the server adapter and browser API wrappers.
- **`npm/`**: The JavaScript client library (`bormashino`). Handles WASM initialization, the JS-Ruby bridge, and DOM updates.
- **`test-app/`**: A reference application demonstrating the usage of Bormashino.
- **`.github/`**: CI/CD workflows for testing and publishing both the Gem and NPM packages.

## Core Architecture

### 1. The Runtime Environment
Bormashino runs Ruby 3.2+ compiled to WebAssembly via WASI (WebAssembly System Interface).
- **`ruby.wasm`**: The core Ruby runtime.
- **`wasi-vfs`**: Used to package the user's Ruby source code and dependencies into a virtual filesystem accessible by the WASM runtime.

### 2. Request/Response Cycle
The framework mimics a standard web server environment entirely within the browser:

1.  **User Interaction**: A user clicks a link or the app loads.
2.  **JS Interception**: The `npm` package intercepts the event (`ruby.js` / `htmlHandlers.js`).
3.  **Bridge Call**: JS invokes `Bormashino::Server.request` inside the Ruby VM via the global `window.bormashino` object.
4.  **Rack Emulation**: `Bormashino::Server` (in `gem/`) constructs a mock Rack environment (using `StringIO` for input/errors) and calls the mounted Sinatra application.
5.  **App Logic**: The Sinatra app (`src/app.rb`) processes the request and returns a response (usually HTML).
6.  **DOM Update**: The JS side receives the string response and updates the `#bormashino-application` DOM element (`applyServerResult.js`).

### 3. Build Process
The build process is managed via Rake tasks (see `test-app/Rakefile` and `gem/lib/bormashino/tasks/bormashino.rake`).
- **Pack**: Bundles the `src/` directory and Gem dependencies into the WASM filesystem using `wasi-vfs`.
- **Digest**: Generates a unique hash for the WASM binary for caching/versioning.

## Key Files & Components

### Ruby Side (`gem/`)
- `lib/bormashino/server.rb`: The pseudo-Rack server. Converts JS calls into Rack requests.
- `lib/bormashino/fetch.rb`: Wrapper for the browser's `fetch` API.
- `lib/bormashino/local_storage.rb`: Wrapper for `localStorage`.

### JavaScript Side (`npm/`)
- `src/ruby.js`: Initializes the Ruby VM (`initVm`), sets up WASI/WasmFs, and manages the communication bridge.
- `src/index.js`: Main entry point exporting the library.

### Application Side (`test-app/`)
- `src/app.rb`: The main Sinatra application.
- `src/bootstrap.rb`: The Ruby entry point loaded by the VM. Mounts the app to `Bormashino::Server`.
- `js/app.js`: The JavaScript entry point. Initializes the VM and starts the router.

## Development Conventions
- **Language**: Ruby 3.2+ (WASM target), JavaScript (ES Modules).
- **Framework**: Sinatra (Ruby), Jest (JS Testing), RSpec (Ruby Testing).
- **Style**: Standard Ruby style (RuboCop), Prettier for JS.
- **Package Management**: Bundler (Ruby), NPM (JS).

## Usage for Agents
When working on this project:
1.  **Context**: Always check if you are working in `gem`, `npm`, or `test-app`. Context switching is frequent.
2.  **Testing**:
    -   Ruby (Gem): `bundle exec rake spec` inside `gem/`.
    -   JS (NPM): `npm test` inside `npm/`.
    -   Integration: `bundle exec rake spec` inside `test-app/`.
3.  **Build**: When changing `test-app` Ruby code, you may need to run `bundle exec rake` to repack the WASM if the changes involve dependencies or filesystem structure, though simple code changes might be hot-loaded depending on the dev server setup (verify `bin/dev`).
