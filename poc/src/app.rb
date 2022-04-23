require 'sinatra/base'
require 'sinatra/form_helpers'

require_relative 'todo'

class App < Sinatra::Base
  helpers Sinatra::FormHelpers
  set :protection, false

  get '/' do
    @todos = []
    erb :index
  end

  post '/' do
    unless params['new-todo'].empty?
      todo = Todo.new({
                        'id' => SecureRandom.uuid,
                        'title' => params['new-todo'],
                        'completed' => false,
                      })
      todo.save
    end

    redirect to('/')
  end
end
