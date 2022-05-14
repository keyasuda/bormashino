require 'rake'
RSpec.configure do |config|
  config.before do
    Rake.application.tasks.each(&:reenable) # Remove persistency between examples
  end
end
