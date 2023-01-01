require 'js'
require 'sinatra/base'
require 'bormashino/fetch'
require 'bormashino/local_storage'

class App < Sinatra::Base
  set :protection, false

  get '/' do
    @world = 'world'

    erb :index
  end

  get '/link' do
    'link clicked'
  end

  get '/get-form-submit' do
    "You GET: #{params}"
  end

  put '/form-submit' do
    "You put: #{params[:value1]}"
  end

  delete '/destroy' do
    '2nd form has submitted'
  end

  get '/fetch' do
    Bormashino::Fetch.new(
      resource: '/fetch.txt',
      resolved_to: '/fetched',
      options: { param1: 'value1', param2: 'value2' },
    ).run

    'initiated'
  end

  get '/fetch2' do
    result = JS.global.fetch('/fetch.txt').await
    ret = result.text.await
    ret.to_s
  end

  post '/fetched' do
    params.inspect
  end

  get '/localstorage' do
    @local_storage = Bormashino::LocalStorage.instance
    5.times.each { |i| @local_storage.set_item("key#{i}", "value#{i}") }
    erb :localstorage
  end

  get '/ls_remove_item' do
    @local_storage = Bormashino::LocalStorage.instance
    @local_storage.remove_item('key2')
    @local_storage.length.to_s
  end

  get '/ls_clear' do
    @local_storage = Bormashino::LocalStorage.instance
    @local_storage.clear
    @local_storage.length.to_s
  end

  get '/sessionstorage' do
    @session_storage = Bormashino::SessionStorage.instance
    5.times.each { |i| @session_storage.set_item("key#{i}", "value#{i}") }
    erb :sessionstorage
  end

  get '/ss_remove_item' do
    @session_storage = Bormashino::SessionStorage.instance
    @session_storage.remove_item('key2')
    @session_storage.length.to_s
  end

  get '/ss_clear' do
    @session_storage = Bormashino::SessionStorage.instance
    @session_storage.clear
    @session_storage.length.to_s
  end
end
