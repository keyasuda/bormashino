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
end
