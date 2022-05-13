require 'rake_helper'
load 'bormashino/tasks/bormashino.rake'
require 'tmpdir'

require 'pry'

RSpec.describe 'bormashino:*', rake: true do
  describe 'download' do
    subject(:task) { Rake.application['bormashino:download'] }

    around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          example.run
        end
      end
    end

    it 'downloads ruby.wasm and wasi_vfs' do
      task.invoke

      expect(`file wasi-vfs`).to include 'ELF 64-bit LSB shared object, x86-64, version 1 (SYSV)'
      expect(`file head-wasm32-unknown-wasi-full-js/usr/local/bin/ruby`).to include 'WebAssembly (wasm) binary module version 0x1 (MVP)'
    end
  end
end
