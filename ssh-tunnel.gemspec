# frozen_string_literal: true

require_relative 'lib/ssh_tunnel/version'

Gem::Specification.new do |s|
  s.name        = 'ssh-tunnel'
  s.version     = SSHTunnel::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nicoladmin@free.fr']
  s.homepage    = 'https://github.com/jbox-web/ssh-tunnel'
  s.summary     = 'A Ruby/GTK3 gem to manage SSH tunnels'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.5.0'

  s.files = %x(git ls-files).split("\n")

  s.bindir      = 'exe'
  s.executables = ['ssh-tunnel']

  s.add_dependency 'activesupport', '>= 5.2'
  s.add_dependency 'gettext'
  s.add_dependency 'gtk3'
  s.add_dependency 'subprocess'

  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov', '~> 0.17.1'
end
