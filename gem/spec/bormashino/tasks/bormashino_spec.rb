require 'rake_helper'
load 'bormashino/tasks/bormashino.rake'
require 'tmpdir'
require 'os'

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

      case
      when OS.linux?
        expect(`file wasi-vfs`).to include 'ELF 64-bit LSB shared object, x86-64, version 1 (SYSV)'
      when OS.mac?
        if OS.host_cpu == 'x86_64'
          expect(`file wasi-vfs`).to include 'Mach-O 64-bit executable x86_64'
        else
          expect(`file wasi-vfs`).to include 'Mach-O 64-bit executable arm64'
        end
      end
      expect(`./wasi-vfs --version`).to include 'wasi-vfs-cli '
      expect(`file head-wasm32-unknown-wasi-full-js/usr/local/bin/ruby`).to include 'WebAssembly (wasm) binary module version 0x1 (MVP)'
    end
  end
end
