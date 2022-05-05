# Bormaŝino

[![CodeQL](https://github.com/keyasuda/bormashino/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/keyasuda/bormashino/actions/workflows/codeql-analysis.yml)
[![test-app integration test](https://github.com/keyasuda/bormashino/actions/workflows/test-app-integration.yml/badge.svg)](https://github.com/keyasuda/bormashino/actions/workflows/test-app-integration.yml)
[![Gem](https://github.com/keyasuda/bormashino/actions/workflows/gem.yml/badge.svg)](https://github.com/keyasuda/bormashino/actions/workflows/gem.yml)
[![NPM](https://github.com/keyasuda/bormashino/actions/workflows/npm.js.yml/badge.svg)](https://github.com/keyasuda/bormashino/actions/workflows/npm.js.yml)

## 概要

Ruby で SPA(single page application)を構築するためのパッケージです。

## 依存関係

主に以下のプロダクトに依存しています。

- [ruby.wasm](https://github.com/ruby/ruby.wasm)
- [wasi-vfs](https://github.com/kateinoigakukun/wasi-vfs)
- [Sinatra](http://sinatrarb.com/)
- [html5-history-router](https://github.com/BusinessDuck/html5-history-router)

## 使用例

- [TodoMVC 移植](https://github.com/keyasuda/bormashino-todomvc)
- [テンプレート](https://github.com/keyasuda/bormashino-app-template)

## 利用方法

[テンプレート](https://github.com/keyasuda/bormashino-app-template)をご利用下さい。

## リリース

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

## ライセンス

[MIT](https://choosealicense.com/licenses/mit/)
