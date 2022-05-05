require 'js'
require 'sinatra/base'
require 'bormashino/fetch'

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
end
