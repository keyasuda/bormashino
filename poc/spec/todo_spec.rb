require_relative '../src/todo'
STORE_KEY = 'todos-bormashino'.freeze

RSpec.describe Todo do
  let(:store) { Bormashino::LocalStorage.instance.store }

  describe 'instance methods' do
    subject { described_class.new(params) }

    let(:params) { { 'id' => 'new-task-id', 'title' => 'task-title', 'completed' => false } }

    it 'stores inputs' do
      expect(subject.id).to eq params['id']
      expect(subject.title).to eq params['title']
      expect(subject.completed).to eq params['completed']
    end

    it 'returns JSON' do
      expect(JSON.parse(subject.to_json)).to eq params
    end

    it 'can be saved as new' do
      subject.save
      expect(store[STORE_KEY]).to eq([params].to_json)
    end

    describe 'update' do
      before { store[STORE_KEY] = [params].to_json }

      let(:updated_title) { 'updated title' }

      it 'can update title' do
        subject.update({ 'title' => updated_title })
        expect(JSON.parse(store[STORE_KEY])[0]['title']).to eq updated_title
      end

      it 'can update completed status' do
        subject.update({ 'completed' => true })
        expect(JSON.parse(store[STORE_KEY])[0]['completed']).to be true
      end

      it 'can be unchecked' do
        subject.update({ 'completed' => true })
        subject.update({ 'completed' => 'false' })
        expect(JSON.parse(store[STORE_KEY])[0]['completed']).to be false
      end
    end

    describe 'delete' do
      subject { described_class.all.first }

      before { store[STORE_KEY] = [params].to_json }

      it 'can be deleted' do
        subject.destroy
        expect(store[STORE_KEY]).to eq '[]'
      end
    end
  end

  describe 'class methods' do
    let(:initial_state) {
      [
        { 'id' => 'id1', 'title' => 'title1', 'completed' => false },
        { 'id' => 'id2', 'title' => 'title2', 'completed' => true },
      ]
    }

    before { store[STORE_KEY] = initial_state.to_json }

    it 'gets the item' do
      actual = described_class.get('id1')
      expect(actual.title).to eq 'title1'
    end

    it 'gets all items' do
      expect(described_class.all.map(&:id)).to eq %w[id1 id2]
    end

    it 'gets completed items' do
      expect(described_class.completed.map(&:completed).uniq).to eq [true]
    end

    it 'gets incompleted items' do
      expect(described_class.incompleted.map(&:completed).uniq).to eq [false]
    end
  end
end
