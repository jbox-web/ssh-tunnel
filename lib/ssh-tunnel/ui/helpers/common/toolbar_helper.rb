# frozen_string_literal: true

module SSHTunnel
  module UI
    module Helpers
      module Common
        module ToolbarHelper

          def initialize(*)
            super

            # Bind listeners
            bind_menu_entries
            bind_toolbar_buttons
          end


          private


            def bind_menu_entries
              signal_connect :destroy do
                @application.quit
              end

              menu_quit.signal_connect :activate do
                @application.quit
              end

              menu_about.signal_connect :activate do
                window = SSHTunnel::UI::Windows::AboutWindow.new(@application)
                window.present
              end
            end


            def bind_toolbar_buttons
              bind_toolbar_button_add
              bind_toolbar_button_edit
              bind_toolbar_button_remove
              bind_toolbar_button_start
              bind_toolbar_button_stop
            end


            def bind_toolbar_button_add
              button_add.tooltip_text = _('Add Host')
              button_add.signal_connect :clicked do
                with_new_host_model do |object|
                  window = SSHTunnel::UI::Windows::HostNewWindow.new(@application, self, object)
                  window.present
                end
              end
            end


            def bind_toolbar_button_edit
              button_edit.tooltip_text = _('Edit Host')
              button_edit.signal_connect :clicked do
                with_host_model do |object|
                  window = SSHTunnel::UI::Windows::HostEditWindow.new(@application, self, object)
                  window.present
                end
              end
            end


            def bind_toolbar_button_remove
              button_remove.tooltip_text = _('Remove Host')
              button_remove.signal_connect :clicked do
                with_host_model do |object|
                  window = SSHTunnel::UI::Windows::HostDeleteWindow.new(@application, self, object)
                  window.present
                end
              end
            end


            def bind_toolbar_button_start
              button_start.tooltip_text = _('Start Tunnel')
              button_start.signal_connect :clicked do
                with_host_model do |object|
                  object.start_tunnels!
                  reload_hosts_treeview
                end
              end
            end


            def bind_toolbar_button_stop
              button_stop.tooltip_text = _('Stop Tunnel')
              button_stop.signal_connect :clicked do
                with_host_model do |object|
                  object.stop_tunnels!
                  reload_hosts_treeview
                end
              end
            end

        end
      end
    end
  end
end
