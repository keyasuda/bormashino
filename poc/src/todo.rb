class Todo
  KEY = 'todos-bormashino'.freeze
  @store = Bormashino::LocalStorage.instance

  attr_reader :id, :title, :completed

  def initialize(params)
    @id = params['id']
    @title = params['title']
    @completed = params['completed']
  end

  def update(params)
    @title = params['title'] || @title
    @completed = params['completed'] if params.keys.include?('completed')
    @completed = false if @completed == 'false'
    save
  end

  def save
    self.class.set(self)
  end

  def destroy
    self.class.delete(self)
  end

  def to_json(*_args)
    { 'id' => @id, 'title' => @title, 'completed' => @completed }.to_json
  end

  def self.all
    JSON.parse(@store.get_item(KEY) || '[]').map { |v| self.new(v) }
  end

  def self.get(id)
    self.all.find { |t| t.id == id }
  end

  def self.completed
    self.all.select(&:completed)
  end

  def self.incompleted
    self.all.reject(&:completed)
  end

  def self.set(item)
    index = self.all.index { |t| t.id == item.id }
    current = if index
                self.all.tap { |a| a[index] = item }
              else
                [self.all, item].flatten
              end
    @store.set_item(KEY, current.to_json)
  end

  def self.delete(item)
    tobe = self.all.reject { |t| t.id == item.id }
    @store.set_item(KEY, tobe.to_json)
  end
end
