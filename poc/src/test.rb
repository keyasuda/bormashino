require 'rack'
Rack::Response # workaround
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
