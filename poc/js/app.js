import { WASI } from "@wasmer/wasi";
import { WasmFs } from "@wasmer/wasmfs";
import { RubyVM } from "ruby-head-wasm-wasi/dist/index.js";
import rubyDigest from './ruby-digest.js'

const main = async () => {
  // Fetch and instntiate WebAssembly binary
  const rubyModule = await WebAssembly.compileStreaming(fetch('/ruby.' + rubyDigest + '.wasm'));

  const wasmFs = new WasmFs();
  const wasi = new WASI({
      bindings: Object.assign(Object.assign({}, WASI.defaultBindings), { fs: wasmFs.fs }),
  });
  const originalWriteSync = wasmFs.fs.writeSync.bind(wasmFs.fs);
  wasmFs.fs.writeSync = function () {
    let fd = arguments[0];
    let text;
    if (arguments.length === 4) {
      text = arguments[1];
    }
    else {
      let buffer = arguments[1];
      text = new TextDecoder("utf-8").decode(buffer);
    }
    const handlers = {
      1: (line) => console.log(line),
      2: (line) => console.warn(line),
    };
    if (handlers[fd])
    handlers[fd](text);
    return originalWriteSync(...arguments);
  };

  const vm = new RubyVM();
  const imports = {
      wasi_snapshot_preview1: wasi.wasiImport,
  };
  vm.addToImports(imports);
  const instance = await WebAssembly.instantiate(rubyModule, imports);
  await vm.setInstance(instance);
  wasi.setMemory(instance.exports.memory);
  instance.exports._initialize();
  vm.initialize(["ruby.wasm", "-I/stub", "-e_=0"]);

  vm.printVersion();
  vm.eval(`
    ENV['GEM_HOME'] = '/src/bundle/ruby/3.2.0+1'
    require "js"
    require_relative '/src/test.rb'
  `);

  document.querySelector('#btn1').addEventListener('click', (e) => {
    let a = vm.eval(`$app_call.call('/')[2].first`)
    document.querySelector('#display').innerHTML = a.toJS()
  })

  document.querySelector('#btn2').addEventListener('click', (e) => {
    let a = vm.eval(`$app_call.call('/hoge')[2].first`)
    document.querySelector('#display').innerHTML = a.toJS()
  })
};

main()
