# frozen_string_literal: true

# Require Gtk3 first. If it fails nothing works.
begin
  require 'gtk3'
rescue GObjectIntrospection::RepositoryError::TypelibNotFound => _e
  puts GObjectIntrospection::Repository.search_path
  puts %x(ls -hal /usr/lib/x86_64-linux-gnu/girepository-1.0)
  puts %x(ls -hal /usr/lib/girepository-1.0)
  puts %x(ls -hal /usr/lib)
  puts %x(ls -hal /)
  require 'gtk3'
end

# Require other libs
require 'fileutils'
require 'json'
require 'yaml'
require 'singleton'
require 'optparse'
require 'tmpdir'
require 'securerandom'
require 'logger'

require 'i18n'
require 'i18n/backend/fallbacks'

require 'subprocess'

require 'active_model'
require 'active_support/concern'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'
require 'ruby2_keywords'

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect 'ssh-tunnel' => 'SSHTunnel'
loader.inflector.inflect 'ui' => 'UI'
loader.inflector.inflect 'cli' => 'CLI'
loader.setup

module SSHTunnel

  ROOT_PATH = Pathname.new File.expand_path('..', __dir__)

  def self.root_path
    ROOT_PATH
  end


  def self.resources_path
    @resources_path ||= root_path.join('resources')
  end


  def self.resources_xml
    @resources_xml ||= resources_path.join('gresources.xml')
  end


  def self.resources_bin
    @resources_bin ||= Pathname.new(Dir.tmpdir).join('gresources.bin')
  end


  def self.locales_path
    root_path.join('config', 'locales', '*.yml')
  end


  def self.current_locale
    Gtk.default_language.to_s.split('-').first.to_sym
  end


  def self.load_config(file)
    @config = SSHTunnel::UI::Models::Config.new(file)
  end


  def self.config
    @config
  end


  def self.logger
    @logger ||= SSHTunnel::Logger.new($stdout, level: Logger::INFO)
  end

end

# Eager load application
loader.eager_load
