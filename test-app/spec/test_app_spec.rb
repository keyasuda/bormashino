RSpec.describe 'test_app', type: :feature, retry: 10 do
  subject { page }

  before do
    visit 'http://localhost:5000'
    loop do
      sleep 1
      begin
        break if page.find(:css, 'h1')
      rescue StandardError
      end
    end
  end

  describe 'initialized app' do
    describe 'body' do
      subject { page.find(:css, 'h1') }

      it { is_expected.to have_text('ruby appが初期化されました。') }
    end

    describe 'head' do
      it { is_expected.to have_title('updated title from index.erb') }
    end
  end

  describe 'GET link' do
    subject { page }

    before { page.find(:css, '#get-link').click }

    it { is_expected.to have_text('link clicked') }
  end

  describe 'form submit' do
    describe 'put' do
      let(:typed_value) { 'あいうえお' }

      before do
        fill_in 'value1', with: typed_value
        click_button 'submit1'
      end

      it { is_expected.to have_text(typed_value) }
      it { is_expected.to have_text('You put: ') }
    end

    describe 'get' do
      let(:typed_value) { 'かきくけこ' }

      before do
        fill_in 'value2', with: typed_value
        click_button 'さぶみっと'
      end

      it { is_expected.to have_text(typed_value) }
      it { is_expected.to have_text('You GET: ') }
      it { expect(page.current_url).to eq 'http://localhost:5000/get-form-submit?value2=%E3%81%8B%E3%81%8D%E3%81%8F%E3%81%91%E3%81%93' }
    end
  end

  describe 'data-bormashino-submit-on' do
    before { check('click to submit the 2nd form') }

    it { is_expected.to have_text('2nd form has submitted') }
  end

  describe 'Bormashino::Fetch' do
    before do
      click_link 'fetch test'
      sleep 1
    end

    it { is_expected.to have_text('{"status"=>"200", "payload"=>"fetched text\n", "options"=>"{\"param1\":\"value1\",\"param2\":\"value2\"}"}') }
  end

  describe 'async/await' do
    before do
      click_link 'JS::Object#await fetch'
      sleep 1
    end

    it { is_expected.to have_text('fetched text') }
  end

  describe 'LocalStorage' do
    before do
      click_link 'localstorage test'
      sleep 1
    end

    it { is_expected.to have_text('length: 5') }
    it { is_expected.to have_text('get_item key3: value3') }

    5.times { |i| it { is_expected.to have_text("key#{i} value#{i}") } }

    describe 'remove_item' do
      before do
        click_link 'remove_item'
        sleep 1
      end

      it { is_expected.to have_text('4') }
    end

    describe 'clear' do
      before do
        click_link 'clear'
        sleep 1
      end

      it { is_expected.to have_text('0') }
    end
  end

  describe 'SessionStorage' do
    before do
      click_link 'sessionstorage test'
      sleep 1
    end

    it { is_expected.to have_text('length: 5') }
    it { is_expected.to have_text('get_item key3: value3') }

    5.times { |i| it { is_expected.to have_text("key#{i} value#{i}") } }

    describe 'remove_item' do
      before do
        click_link 'remove_item'
        sleep 1
      end

      it { is_expected.to have_text('4') }
    end

    describe 'clear' do
      before do
        click_link 'clear'
        sleep 1
      end

      it { is_expected.to have_text('0') }
    end
  end

  describe 'bormashino:updated event' do
    before_event = nil
    subject { page.find(:css, '#bormashino-updated-event').text }

    before do
      before_event = page.find(:css, '#bormashino-updated-event').text
      click_link 'link'
    end

    it { is_expected.not_to eq before_event }
  end
end
