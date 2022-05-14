require 'fileutils'
require 'uri'
require 'os'
require 'digest/md5'

RUBY_RELEASE = 'https://github.com/ruby/ruby.wasm/releases/download/2022-04-25-a/ruby-head-wasm32-unknown-wasi-full-js.tar.gz'.freeze
WASI_VFS_RELEASE = 'https://github.com/kateinoigakukun/wasi-vfs/releases/download/v0.1.1/wasi-vfs-cli-x86_64-unknown-linux-gnu.zip'.freeze
WASI_VFS_RELEASE_MAC_X86_64 = 'https://github.com/kateinoigakukun/wasi-vfs/releases/download/v0.1.1/wasi-vfs-cli-x86_64-apple-darwin.zip'.freeze
WASI_VFS_RELEASE_MAC_ARM64 = 'https://github.com/kateinoigakukun/wasi-vfs/releases/download/v0.1.1/wasi-vfs-cli-aarch64-apple-darwin.zip'.freeze

RUBY_ROOT = File.basename(URI(RUBY_RELEASE).path).split('.').first.sub('ruby-', '')
WASI_VFS = './wasi-vfs'.freeze
TMP = 'tmp'.freeze
DIGEST = 'js/ruby-digest.js'.freeze

namespace :bormashino do
  desc 'download ruby.wasm and wasi-vfs'
  task :download do
    system "curl -L #{RUBY_RELEASE} | tar xz"
    FileUtils.rm(File.join(RUBY_ROOT, '/usr/local/lib/libruby-static.a'))
    FileUtils.rm_rf(File.join(RUBY_ROOT, '/usr/local/include'))

    case
    when OS.linux?
      system "curl -L '#{WASI_VFS_RELEASE}' | gzip -d > wasi-vfs"
    when OS.mac?
      if OS.host_cpu == 'x86_64'
        system "curl -L -o wasi-vfs.zip '#{WASI_VFS_RELEASE_MAC_X86_64}'"
      else
        system "curl -L -o wasi-vfs.zip '#{WASI_VFS_RELEASE_MAC_ARM64}'"
      end
      system 'unzip wasi-vfs.zip'
      system 'rm wasi-vfs.zip'
    end

    system 'chmod u+x wasi-vfs'
  end

  desc 'embed ruby scripts with wasi-vfs'
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

  desc 'add MD5 to packed ruby.wasm and write JS for importing'
  task :digest, [:destination] do |_, args|
    digest = Digest::MD5.file('tmp/ruby.wasm').hexdigest
    FileUtils.cp('tmp/ruby.wasm', "#{args[:destination]}/ruby.#{digest}.wasm")
    File.open(DIGEST, 'w') { |f|
      f.puts "export default rubyDigest = '#{digest}'
  "
    }
  end

  desc 'clean built ruby.wasm files'
  task :delete_wasms, [:target] do |_, args|
    Dir.glob(File.join(args[:target], 'ruby.*.wasm')).each { |f| FileUtils.rm(f) }
  end
end
