# frozen_string_literal: true

# Require Gtk3 first. If it fails nothing works.
begin
  require 'gtk3'
rescue GObjectIntrospection::RepositoryError::TypelibNotFound => e
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

require 'gettext'
require 'subprocess'

require 'active_support/concern'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect 'ssh-tunnel' => 'SSHTunnel'
loader.inflector.inflect 'ui' => 'UI'
loader.setup

module SSHTunnel

  def self.base_path
    @base_path ||= Pathname.new File.expand_path('..', __dir__)
  end


  def self.resources_path
    @resources_path ||= base_path.join('resources')
  end


  def self.resources_xml
    @resources_xml ||= resources_path.join('gresources.xml')
  end


  def self.user_data_path
    @user_data_path ||= Pathname.new(File.expand_path('~/.config/ssh-tunnel'))
  end


  def self.locales_path
    @locales_path ||= user_data_path.join('locales')
  end


  def self.tmp_path
    @tmp_path ||= user_data_path.join('tmp')
  end


  def self.resources_bin
    @resources_bin ||= tmp_path.join('gresource.bin')
  end


  def self.config_file_path
    @config_file_path ||= user_data_path.join('config.yml')
  end


  def self.config
    @config ||= load_config(config_file_path)
  end


  def self.load_config(file)
    SSHTunnel::UI::Models::Config.new(file)
  end

end
