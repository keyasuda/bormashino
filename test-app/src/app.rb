require 'sinatra/base'

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
end
