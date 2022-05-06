RSpec.describe 'test_app', type: :feature do
  subject { page }

  before do
    visit 'http://localhost:5000'
    loop do
      sleep 1
      break if page.find(:css, 'h1')
    end
  end

  describe 'initialized app' do
    subject { page.find(:css, 'h1') }

    it { is_expected.to have_text('ruby appが初期化されました。') }
  end

  describe 'GET link' do
    subject { page }

    before { page.find(:css, '#get-link').click }

    it { is_expected.to have_text('link clicked') }
  end

  describe 'form submit' do
    let(:typed_value) { 'あいうえお' }

    before do
      fill_in 'value1', with: typed_value
      click_button 'submit1'
    end

    it { is_expected.to have_text(typed_value) }
    it { is_expected.to have_text('You put: ') }
  end

  describe 'data-bormashino-submit-on' do
    before { check('click to submit the 2nd form') }

    it { is_expected.to have_text('2nd form has submitted') }
  end

  describe 'fetch api' do
    before do
      click_link 'fetch test'
      sleep 1
    end

    it { is_expected.to have_text('{"status"=>"200", "payload"=>"fetched text\n"}') }
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
