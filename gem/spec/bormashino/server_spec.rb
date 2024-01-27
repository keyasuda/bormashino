require 'sinatra/base'
require_relative '../../lib/bormashino/server'
class MockApp < Sinatra::Base
  set :protection, false

  get '/get' do
    "get action #{params[:param]}"
  end

  post '/post' do
    "post params #{params[:param]}"
  end

  put '/put' do
    "put params #{params[:param]}"
  end

  patch '/patch' do
    "patch params #{params[:param]}"
  end

  delete '/delete' do
    "delete params #{params[:param]}"
  end

  get '/redirect_back' do
    redirect back
  end
end

RSpec.describe Bormashino::Server do
  describe 'mount check' do
    subject { described_class.mounted? }

    it { is_expected.to be false }

    describe 'after mounted' do
      before { described_class.mount(MockApp) }

      it { is_expected.to be true }
    end
  end

  describe 'mount' do
    subject { described_class.instance_variable_get(:@app) }

    before { described_class.mount(MockApp) }

    it 'has app instance' do
      expect(subject.class).to eq(MockApp.new.class)
    end
  end

  describe 'psuedo HTTP request' do
    describe 'GET with no queries' do
      subject { JSON.parse described_class.request('GET', '/get') }

      it 'GETs /get to the app' do
        expect(subject.first).to eq 200
        expect(subject.last).to eq ['get action ']
      end
    end

    describe 'http method name in lower cases' do
      subject { JSON.parse described_class.request('get', '/get') }

      it 'accepts lower cases' do
        expect(subject.first).to eq 200
      end
    end

    describe 'GET with queries' do
      subject { JSON.parse described_class.request('GET', '/get?param=foo') }

      it 'GETs /get to the app' do
        expect(subject.first).to eq 200
        expect(subject.last).to eq ['get action foo']
      end
    end

    context 'without payloads' do
      subject { JSON.parse described_class.request(method, path) }

      describe 'POST' do
        let(:method) { 'post' }
        let(:path) { '/post' }

        it 'returns 200' do
          expect(subject.first).to eq 200
          expect(subject.last).to eq ['post params ']
        end
      end

      describe 'PUT' do
        let(:method) { 'put' }
        let(:path) { '/put' }

        it 'returns 200' do
          expect(subject.first).to eq 200
          expect(subject.last).to eq ['put params ']
        end
      end

      describe 'PATCH' do
        let(:method) { 'patch' }
        let(:path) { '/patch' }

        it 'returns 200' do
          expect(subject.first).to eq 200
          expect(subject.last).to eq ['patch params ']
        end
      end

      describe 'DELETE' do
        let(:method) { 'delete' }
        let(:path) { '/delete' }

        it 'returns 200' do
          expect(subject.first).to eq 200
          expect(subject.last).to eq ['delete params ']
        end
      end
    end

    context 'with payloads' do
      subject { JSON.parse described_class.request(method, path, 'param=foo') }

      describe 'POST' do
        let(:method) { 'post' }
        let(:path) { '/post' }

        it 'returns 200' do
          expect(subject.first).to eq 200
          expect(subject.last).to eq ['post params foo']
        end
      end

      describe 'PUT' do
        let(:method) { 'put' }
        let(:path) { '/put' }

        it 'returns 200' do
          expect(subject.first).to eq 200
          expect(subject.last).to eq ['put params foo']
        end
      end

      describe 'PATCH' do
        let(:method) { 'patch' }
        let(:path) { '/patch' }

        it 'returns 200' do
          expect(subject.first).to eq 200
          expect(subject.last).to eq ['patch params foo']
        end
      end

      describe 'DELETE' do
        let(:method) { 'delete' }
        let(:path) { '/delete' }

        it 'returns 200' do
          expect(subject.first).to eq 200
          expect(subject.last).to eq ['delete params foo']
        end
      end
    end

    describe 'referer' do
      subject { JSON.parse described_class.request('GET', '/redirect_back', '', '/referer') }

      it 'sends referer' do
        expect(subject.first).to eq 302
        expect(subject[1]['location']).to eq 'http://example.com:0/referer'
      end
    end
  end
end
