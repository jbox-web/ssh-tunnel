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

              menu_quit.label = t('menu.quit')
              menu_quit.signal_connect :activate do
                @application.quit
              end

              menu_about.label = t('menu.about')
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
              button_add.tooltip_text = t('tooltip.host.add')
              button_add.signal_connect :clicked do
                with_new_host_model do |object|
                  window = SSHTunnel::UI::Windows::Hosts::NewWindow.new(@application, self, object)
                  window.present
                end
              end
            end


            def bind_toolbar_button_edit
              button_edit.tooltip_text = t('tooltip.host.edit')
              button_edit.signal_connect :clicked do
                with_host_model do |object|
                  window = SSHTunnel::UI::Windows::Hosts::EditWindow.new(@application, self, object)
                  window.present
                end
              end
            end


            def bind_toolbar_button_remove
              button_remove.tooltip_text = t('tooltip.host.remove')
              button_remove.signal_connect :clicked do
                with_host_model do |object|
                  window = SSHTunnel::UI::Windows::Hosts::DeleteWindow.new(@application, self, object)
                  window.present
                end
              end
            end


            def bind_toolbar_button_start
              button_start.tooltip_text = t('tooltip.tunnel.start')
              button_start.signal_connect :clicked do
                with_host_model do |object|
                  object.start_tunnels!
                  reload_hosts_treeview
                end
              end
            end


            def bind_toolbar_button_stop
              button_stop.tooltip_text = t('tooltip.tunnel.stop')
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
