require 'rack'
# rubocop:disable Lint/Void
Rack::Response # workaround
# rubocop:enable Lint/Void
require 'stringio'
require 'sinatra/base'

class MyApp < Sinatra::Base
  set :protection, false
  get '/' do
    # 'Hello world!'
    erb :index
  end

  get '/hoge' do
    'Hello hogehoge!'
  end
end

app = MyApp.new
# rubocop:disable Style/GlobalVars
$app_call =
  lambda do |path|
    app.call({
               'REQUEST_METHOD' => 'GET',
               'QUERY_STRING' => '',
               'PATH_INFO' => path,
               'rack.input' => StringIO.new(''),
               'rack.errors' => StringIO.new(''),
             })
  end
# rubocop:enable Style/GlobalVars
