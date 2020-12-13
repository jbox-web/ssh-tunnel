require 'simplecov'
require 'rspec'
require 'factory_bot'

# Start Simplecov
SimpleCov.start do
  add_filter 'spec/'
end

# Configure RSpec
RSpec.configure do |config|
  config.color = true
  config.fail_fast = false

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # disable monkey patching
  # see: https://relishapp.com/rspec/rspec-core/v/3-8/docs/configuration/zero-monkey-patching-mode
  config.disable_monkey_patching!

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end

require 'ssh-tunnel'
