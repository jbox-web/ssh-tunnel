# frozen_string_literal: true

require 'simplecov'
require 'simplecov_json_formatter'

# fix for https://github.com/thoughtbot/factory_bot/issues/1690
require 'active_support/inflector'
require 'factory_bot'

# Start Simplecov
SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::JSONFormatter])
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

  config.raise_errors_for_deprecations!

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end

require 'ssh-tunnel'
