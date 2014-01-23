require "simplecov"

require "active_record"
require "bcdatabase"
ActiveRecord::Base.establish_connection(Bcdatabase.load[:has_unique_three_letter_code, "test"])

require "has_unique_three_letter_code"

Dir[File.expand_path("#{__FILE__}/../support/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.order = "random"
  config.before(:suite) do
    CreateClients.up
  end
  config.after(:suite) do
    CreateClients.down
  end
  config.around(:each) do |test|
    Client.transaction do
      test.run
      raise ActiveRecord::Rollback
    end
  end
end
