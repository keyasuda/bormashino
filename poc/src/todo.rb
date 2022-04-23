class Todo
  KEY = 'todos-bormashino'.freeze
  @store = Bormashino::LocalStorage.instance

  attr_reader :id, :title, :completed

  def initialize(params)
    @id = params['id']
    @title = params['title']
    @completed = params['completed']
  end

  def save
    self.class.set(self)
  end

  def to_json(*_args)
    { 'id' => @id, 'title' => @title, 'completed' => @completed }.to_json
  end

  def self.all
    JSON.parse(@store.get_item(KEY) || '{}').transform_values { |v| self.new(v) }
  end

  def self.get(id)
    self.all[id]
  end

  def self.completed
    self.all.values.select(&:completed)
  end

  def self.incompleted
    self.all.values.reject(&:completed)
  end

  def self.set(item)
    current = self.all.merge({ item.id => item })
    @store.set_item(KEY, current.to_json)
  end
end
