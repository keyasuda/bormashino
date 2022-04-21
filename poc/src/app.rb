require 'sinatra/base'
require 'sinatra/form_helpers'

class App < Sinatra::Base
  helpers Sinatra::FormHelpers
  set :protection, false

  get '/' do
    @todos = []
    erb :index
  end

  post '/' do
    p params['new-todo']
    redirect to('/')
  end
end
