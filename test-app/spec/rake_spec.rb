require 'rake'
require 'fileutils'
require 'os'
require 'tmpdir'
require 'digest/md5'

RSpec.configure do |config|
  config.before do
    Rake.application.tasks.each(&:reenable) # Remove persistency between examples
  end
end

load 'bormashino/tasks/bormashino.rake'

RSpec.describe 'bormashino:*', rake: true do
  let(:tmpdir) { Dir.mktmpdir }

  describe 'pack' do
    before do
      FileUtils.rm_rf('tmp/')
      Rake.application['bormashino:pack'].invoke
    end

    it 'creates ./tmp/' do
      expect(Dir.glob('tmp/').size).to eq 1
    end

    it 'puts ruby.wasm into ./tmp/' do
      expect(Dir.glob('tmp/ruby.wasm').size).to eq 1
    end

    if OS.linux?
      it 'puts ruby.wasm which is WASM binary' do
        expect(`file tmp/ruby.wasm`).to include 'WebAssembly (wasm) binary module version 0x1 (MVP)'
      end
    end
  end

  describe 'digest' do
    subject { Dir.glob(File.join(tmpdir, 'ruby.*.wasm')).first }

    before do
      Rake.application['bormashino:digest'].invoke(tmpdir)
    end

    it 'puts ruby.wasm to tmpdir' do
      expect(File.exist?(subject)).to be true
    end

    it 'puts ruby.wasm with MD5 in the filename' do
      expected = Digest::MD5.file(subject).hexdigest
      expect(subject).to include expected
    end
  end

  describe 'delete_wasms' do
    subject { Dir.glob(File.join(tmpdir, 'ruby.*.wasm')).first }

    before do
      Rake.application['bormashino:digest'].invoke(tmpdir)
    end

    it 'has ruby.*.wasm' do
      expect(File.exist?(subject)).to be true
    end

    describe 'delete' do
      before { Rake.application['bormashino:delete_wasms'].invoke(tmpdir) }

      it 'doesnt have ruby.*.wasm' do
        expect(subject).to be_nil
      end
    end
  end
end
