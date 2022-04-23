require 'sinatra/base'
require_relative 'todo'

class App < Sinatra::Base
  set :protection, false

  get '/' do
    @todos = Todo.all
    @remaining_count = Todo.incompleted.size

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

  put '/todos/:id' do |id|
    todo = Todo.get(id)
    values = params.select { |k, _v| %w[title completed].include?(k) }
    todo.update(values)

    redirect to('/')
  end

  delete '/todos/:id' do |id|
    Todo.get(id).destroy
    redirect to('/')
  end
end
