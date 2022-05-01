# Bormaŝino

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

## 利用方法

TBD

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
