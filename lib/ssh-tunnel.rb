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


module SSHTunnel

  module UI
    autoload :Application, 'ssh_tunnel/ui/application'
    autoload :StatusIcon,  'ssh_tunnel/ui/status_icon'

    module Helpers
      autoload :ApplicationWindowHelper, 'ssh_tunnel/ui/windows/helpers/application_window_helper'
      autoload :HostWindowHelper,        'ssh_tunnel/ui/windows/helpers/host_window_helper'
      autoload :TunnelWindowHelper,      'ssh_tunnel/ui/windows/helpers/tunnel_window_helper'

      module Common
        autoload :FormHelper,              'ssh_tunnel/ui/windows/helpers/common/form_helper'
        autoload :MinimizeHelper,          'ssh_tunnel/ui/windows/helpers/common/minimize_helper'
        autoload :ModalHelper,             'ssh_tunnel/ui/windows/helpers/common/modal_helper'
        autoload :ToolbarHelper,           'ssh_tunnel/ui/windows/helpers/common/toolbar_helper'
        autoload :TranslationHelper,       'ssh_tunnel/ui/windows/helpers/common/translation_helper'
      end
    end

    module Models
      autoload :Config, 'ssh_tunnel/ui/models/config'
      autoload :Host,   'ssh_tunnel/ui/models/host'
      autoload :Tunnel, 'ssh_tunnel/ui/models/tunnel'
    end

    module Windows
      autoload :AboutWindow,        'ssh_tunnel/ui/windows/about_window'
      autoload :ApplicationWindow,  'ssh_tunnel/ui/windows/application_window'
      autoload :HostNewWindow,      'ssh_tunnel/ui/windows/host_new_window'
      autoload :HostEditWindow,     'ssh_tunnel/ui/windows/host_edit_window'
      autoload :HostDeleteWindow,   'ssh_tunnel/ui/windows/host_delete_window'
      autoload :TunnelNewWindow,    'ssh_tunnel/ui/windows/tunnel_new_window'
      autoload :TunnelEditWindow,   'ssh_tunnel/ui/windows/tunnel_edit_window'
      autoload :TunnelDeleteWindow, 'ssh_tunnel/ui/windows/tunnel_delete_window'
    end
  end


  def self.base_path
    @base_path ||= Pathname.new File.expand_path('..', __dir__)
  end


  def self.resources_path
    @resources_path ||= base_path.join('lib', 'ssh_tunnel', 'ui', 'resources')
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
