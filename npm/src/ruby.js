import { WASI } from '@wasmer/wasi'
import { WasmFs } from '@wasmer/wasmfs'
import { RubyVM } from 'ruby-head-wasm-wasi/dist/index.js'
import { router, hookTransitionElements } from './htmlHandlers.js'

const vm = new RubyVM()

const currentPath = () => location.href.replace(location.origin, '')

export const mount = () => router.always(() => request('get', currentPath()))

export const request = (
  method,
  path,
  payload = '',
  referer = currentPath()
) => {
  const target = document.querySelector('#bormashino-application')

  const ret = requestToServer(method, path, payload, referer)
  applyServerResult(ret, target)
}

// JSでの値をRubyでの値に変換する
// JS obj -> JSON -> url-encoded str -> (vm.eval) -> JSON -> Ruby obj
const toRbValue = (v) => {
  const input = "'" + encodeURIComponent(JSON.stringify(v)) + "'"
  return vm
    .eval('JSON')
    .call('parse', vm.eval('CGI').call('unescape', vm.eval(input)))
}

export const initVm = async (
  rubyUri,
  initializeOption = ['ruby.wasm', '-I/stub', '-EUTF-8', '-e_=0']
) => {
  const rubyModule = await WebAssembly.compileStreaming(fetch(rubyUri))

  const wasmFs = new WasmFs()
  const wasi = new WASI({
    bindings: Object.assign(Object.assign({}, WASI.defaultBindings), {
      fs: wasmFs.fs,
    }),
  })
  const originalWriteSync = wasmFs.fs.writeSync.bind(wasmFs.fs)
  wasmFs.fs.writeSync = function () {
    let fd = arguments[0]
    let text
    if (arguments.length === 4) {
      text = arguments[1]
    } else {
      let buffer = arguments[1]
      text = new TextDecoder('utf-8').decode(buffer)
    }
    const handlers = {
      1: (line) => console.log(line),
      2: (line) => console.warn(line),
    }
    if (handlers[fd]) handlers[fd](text)
    return originalWriteSync(...arguments)
  }

  const imports = {
    wasi_snapshot_preview1: wasi.wasiImport,
  }

  vm.addToImports(imports)
  const instance = await WebAssembly.instantiate(rubyModule, imports)
  await vm.setInstance(instance)
  wasi.setMemory(instance.exports.memory)
  instance.exports._initialize()
  vm.initialize(initializeOption)

  vm.eval(`
    ENV['GEM_HOME'] = '/src/bundle/ruby/3.2.0+1'
    # workaround
    require 'rack'
    Rack::Response
    require 'cgi'
    require 'json/pure'
  `)

  return vm
}

const requestToServer = (method, path, payload, referer) => {
  const server = vm.eval('Bormashino::Server')
  const ret = server.call(
    'request',
    toRbValue(method.toUpperCase()),
    toRbValue(path),
    toRbValue(payload),
    toRbValue(referer)
  )

  return ret
}

export const applyServerResult = (serverRet, target) => {
  const ret = JSON.parse(serverRet.toJS())

  // 現在フォーカスが当たっている要素のインデックスを取得
  const focusedPos = Array.from(
    document.querySelectorAll('input,textarea,button')
  ).indexOf(document.activeElement)

  switch (ret[0]) {
    case 200:
      target.innerHTML = ret[2][0]
      hookTransitionElements(target, request)
      // フォーカスを当て直す
      if (focusedPos > -1) {
        const target = Array.from(
          document.querySelectorAll('input,textarea,button')
        )[focusedPos]
        if (target) target.focus()
      }
      break

    case 302:
      const loc = new URL(ret[1]['Location'])
      const path = loc.pathname + loc.search
      router.pushState(path)
      break

    default:
      console.error(ret)
      target.innerHTML = ret[2][0]
  }
}
