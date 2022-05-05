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

  put '/form-submit' do
    "You put: #{params[:value1]}"
  end

  delete '/destroy' do
    '2nd form has submitted'
  end

  get '/fetch' do
    Bormashino::Fetch.new(resource: '/fetch.txt', resolved_to: '/fetched').run

    'initiated'
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
end
