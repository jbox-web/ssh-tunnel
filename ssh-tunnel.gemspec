# frozen_string_literal: true

require_relative 'lib/ssh-tunnel/version'

Gem::Specification.new do |s|
  s.name        = 'ssh-tunnel'
  s.version     = SSHTunnel::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nicoladmin@free.fr']
  s.homepage    = 'https://github.com/jbox-web/ssh-tunnel'
  s.summary     = 'A Ruby/GTK3 gem to manage SSH tunnels'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 3.2.0'

  s.files = %x(git ls-files).split("\n")

  s.bindir      = 'exe'
  s.executables = ['ssh-tunnel']

  s.add_dependency 'activemodel', '>= 7.0'
  s.add_dependency 'activesupport', '>= 7.0'
  s.add_dependency 'gtk3'
  s.add_dependency 'i18n'
  s.add_dependency 'subprocess'
  s.add_dependency 'zeitwerk'
end
