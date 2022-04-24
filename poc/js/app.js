import { WASI } from '@wasmer/wasi'
import { WasmFs } from '@wasmer/wasmfs'
import { RubyVM } from 'ruby-head-wasm-wasi/dist/index.js'
import rubyDigest from './ruby-digest.js'

import { Router } from 'html5-history-router'
const router = new Router()
router.always(() =>
  requestToServer('get', location.href.replace(location.origin, ''), null)
)

const vm = new RubyVM()

// JSでの値をRubyでの値に変換する
const toRbValue = (v) => {
  const utils = vm.eval('Bormashino::Utils')
  const input = encodeURIComponent(JSON.stringify(v))
  return utils.call('to_rb_value', vm.eval("'" + input + "'"))
}

const applyServerResult = (serverRet) => {
  const ret = JSON.parse(serverRet.toJS())

  const target = document.querySelector('#display')
  switch (ret[0]) {
    case 200:
      target.innerHTML = ret[2][0]
      hookTransitionElements()
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

const requestToServer = (method, path, payload) => {
  const server = vm.eval('Bormashino::Server')
  let ret

  switch (method.toLowerCase()) {
    case 'get':
      ret = server.call('get', toRbValue(path))
      break

    case 'post':
    case 'put':
    case 'patch':
    case 'delete':
      ret = server.call(
        method.toLowerCase(),
        toRbValue(path),
        toRbValue(payload)
      )
      break
  }

  applyServerResult(ret)
}

const formSubmitHook = (e) => {
  e.preventDefault()
  const form = e.target
  const action = form.action
  const method = form.attributes['method'].value
  const payload = new URLSearchParams(new FormData(form)).toString()

  requestToServer(method, new URL(action).pathname, payload)
}

const formInputEventHook = (e, form) => {
  e.preventDefault()
  form.dispatchEvent(new Event('submit'))
}

const aClickEventHook = (e) => {
  e.preventDefault()
  router.pushState(e.target.href)
}

const hookTransitionElements = () => {
  document.querySelectorAll('a').forEach((a) => {
    if (a.href.startsWith(location.origin)) {
      a.addEventListener('click', aClickEventHook, false)
    }
  })

  document.querySelectorAll('form').forEach((f) => {
    f.addEventListener('submit', formSubmitHook, false)

    f.querySelectorAll('input').forEach((i) => {
      const eventAttr = i.attributes['data-bormashino-submit-on']
      if (eventAttr) {
        i.addEventListener(
          eventAttr.value,
          (e) => formInputEventHook(e, f),
          false
        )
      }
    })
  })
}

const main = async () => {
  // Fetch and instntiate WebAssembly binary
  const rubyModule = await WebAssembly.compileStreaming(
    fetch('/ruby.' + rubyDigest + '.wasm')
  )

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
  vm.initialize(['ruby.wasm', '-I/stub', '-EUTF-8', '-e_=0'])

  vm.printVersion()
  vm.eval(`
    ENV['GEM_HOME'] = '/src/bundle/ruby/3.2.0+1'
    require 'js'
    require 'json/pure'
    require_relative '/src/bormashino.rb'
    require_relative '/src/bootstrap.rb'
  `)

  requestToServer('get', location.href.replace(location.origin, ''), null)
}

main()
