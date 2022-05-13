require 'fileutils'
require 'uri'
require 'os'

RUBY_RELEASE = 'https://github.com/ruby/ruby.wasm/releases/download/2022-04-25-a/ruby-head-wasm32-unknown-wasi-full-js.tar.gz'.freeze
WASI_VFS_RELEASE = 'https://github.com/kateinoigakukun/wasi-vfs/releases/download/v0.1.1/wasi-vfs-cli-x86_64-unknown-linux-gnu.zip'.freeze
WASI_VFS_RELEASE_MAC = 'https://github.com/kateinoigakukun/wasi-vfs/releases/download/v0.1.1/wasi-vfs-cli-aarch64-apple-darwin.zip'.freeze

RUBY_ROOT = File.basename(URI(RUBY_RELEASE).path).split('.').first.sub('ruby-', '')
WASI_VFS = './wasi-vfs'.freeze
TMP = 'tmp'.freeze
DIGEST = 'js/ruby-digest.js'.freeze

namespace :bormashino do
  desc 'ruby.wasm及びwasi-vfsをダウンロードする'
  task :download do
    system "curl -L #{RUBY_RELEASE} | tar xz"
    FileUtils.rm(File.join(RUBY_ROOT, '/usr/local/lib/libruby-static.a'))
    FileUtils.rm_rf(File.join(RUBY_ROOT, '/usr/local/include'))

    case
    when OS.linux?
      system "curl -L '#{WASI_VFS_RELEASE}' | gzip -d > wasi-vfs"
    when OS.mac?
      system "curl -L -o wasi-vfs.zip '#{WASI_VFS_RELEASE_MAC}'"
      system 'unzip wasi-vfs.zip'
      system 'rm wasi-vfs.zip'
    end

    system 'chmod u+x wasi-vfs'
  end

  desc 'wasi_vfsでアプリに使用するRubyスクリプト群を埋め込む'
  task :pack, [:additional_args] do |_, args|
    gem_dir = Gem::Specification.find_by_name('bormashino').gem_dir

    FileUtils.mkdir_p('tmp')
    system([
      "#{WASI_VFS} pack",
      "#{RUBY_ROOT}/usr/local/bin/ruby",
      "--mapdir /usr::#{RUBY_ROOT}/usr",
      '--mapdir /src::./src',
      "--mapdir /stub::'#{gem_dir}/lib/bormashino/stub'",
      args[:additional_args],
      '-o tmp/ruby.wasm',
    ].compact.join(' '))
  end

  desc 'pack済みのruby.wasmのMD5を取りファイル名につけてコピーし、import用のJSを出力する'
  task :digest, [:destination] do |_, args|
    digest = `md5sum tmp/ruby.wasm`.split.first
    FileUtils.cp('tmp/ruby.wasm', "#{args[:destination]}/ruby.#{digest}.wasm")
    File.open(DIGEST, 'w') { |f|
      f.puts "export default rubyDigest = '#{digest}'
  "
    }
  end

  desc '指定ディレクトリ中のdigest付きruby.wasmを削除する'
  task :delete_wasms, [:target] do |_, args|
    Dir.glob(File.join(args[:target], 'ruby.*.wasm')).each { |f| FileUtils.rm(f) }
  end
end
