# Bormaŝino

[![CodeQL](https://github.com/keyasuda/bormashino/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/keyasuda/bormashino/actions/workflows/codeql-analysis.yml)
[![test-app integration test](https://github.com/keyasuda/bormashino/actions/workflows/test-app-integration.yml/badge.svg)](https://github.com/keyasuda/bormashino/actions/workflows/test-app-integration.yml)
[![Gem](https://github.com/keyasuda/bormashino/actions/workflows/gem.yml/badge.svg)](https://github.com/keyasuda/bormashino/actions/workflows/gem.yml)
[![NPM](https://github.com/keyasuda/bormashino/actions/workflows/npm.js.yml/badge.svg)](https://github.com/keyasuda/bormashino/actions/workflows/npm.js.yml)

## Overview

A package to build SPAs (Single Page Applications) with Ruby.

## Dependencies

Mainly this package depends on these:

- [ruby.wasm](https://github.com/ruby/ruby.wasm)
- [wasi-vfs](https://github.com/kateinoigakukun/wasi-vfs)
- [Sinatra](http://sinatrarb.com/)
- [html5-history-router](https://github.com/BusinessDuck/html5-history-router)

## Examples

- [a port of TodoMVC](https://github.com/keyasuda/bormashino-todomvc)
- [GSI maps integration demo](https://github.com/keyasuda/bormashino-demo-gsi-maps)
- [app template](https://github.com/keyasuda/bormashino-app-template)

## How to use

See [app template](https://github.com/keyasuda/bormashino-app-template).

## Releasing

### rubygem

```bash
$ cd gem
$ bundle exec rake build
$ gem push pkg/bormashino-XXX.gem
```

### npm package

```bash
$ cd npm
$ npm publish
```

## License

[MIT](https://choosealicense.com/licenses/mit/)
