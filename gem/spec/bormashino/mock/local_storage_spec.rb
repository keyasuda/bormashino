# frozen_string_literal: true

require_relative '../../../lib/bormashino/mock/local_storage'
# rubocop:disable RSpec::FilePath
RSpec.describe Bormashino::LocalStorage do
  subject { described_class.instance }

  it 'exposes internal hash as store' do
    expect(subject.store).to eq({})
  end

  it 'sets key-value pair into store' do
    subject.set_item('key', 'value')
    expect(subject.store['key']).to eq 'value'
  end

  describe 'get items' do
    before { 4.times { |i| subject.set_item("key#{i}", "value#{i}") } }
    it 'returns the value' do
      expect(subject.get_item('key2')).to eq 'value2'
    end

    it 'returns the position of the key' do
      expect(subject.key(2)).to eq 'key1'
    end

    describe 'key manipulation' do
      it 'removes the item' do
        subject.remove_item('key1')
        expect(subject.store['key1']).to eq nil
      end

      it 'clears everything' do
        subject.clear
        expect(subject.store).to eq({})
      end
    end
  end
end
# rubocop:enable RSpec::FilePath
