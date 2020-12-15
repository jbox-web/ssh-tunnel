# frozen_string_literal: true

module SSHTunnel
  module UI
    module Helpers
      module ApplicationWindowHelper

        include SSHTunnel::UI::Helpers::Common::MinimizeHelper
        include SSHTunnel::UI::Helpers::Common::ToolbarHelper
        include SSHTunnel::UI::Helpers::Common::TranslationHelper
        include SSHTunnel::UI::Helpers::Common::TreeViewHelper


        def self.included(base)
          base.extend(ClassMethods)
          base.extend(SSHTunnel::UI::Helpers::Common::FormHelper::ClassMethods)
        end


        module ClassMethods

          MENU_ITEMS      = %w[quit about].freeze
          TOOLBAR_BUTTONS = %w[add edit remove start stop].freeze

          def init
            bind_menu_entries(MENU_ITEMS)
            bind_buttons(TOOLBAR_BUTTONS)
          end

        end


        def load_hosts_treeview
          # create treeview
          treeview_model  = create_hosts_treeview_model(all_hosts)
          @hosts_treeview = create_hosts_treeview(treeview_model)

          # Render treeview
          hosts_scrolled_window.shadow_type = :etched_in
          hosts_scrolled_window.set_policy(:automatic, :automatic)
          hosts_scrolled_window.add(@hosts_treeview)
          @hosts_treeview.show
        end


        def reload_hosts_treeview
          @hosts_treeview.destroy
          load_hosts_treeview
        end


        private


          HOST_STATE_COLUMN         = 0
          HOST_UUID_COLUMN          = 1
          HOST_NAME_COLUMN          = 2
          HOST_HOST_COLUMN          = 3
          HOST_USER_COLUMN          = 4
          HOST_PORT_COLUMN          = 5
          TUNNEL_NAME_COLUMN        = 6
          TUNNEL_TYPE_COLUMN        = 7
          TUNNEL_LOCAL_HOST_COLUMN  = 8
          TUNNEL_LOCAL_PORT_COLUMN  = 9
          TUNNEL_REMOTE_HOST_COLUMN = 10
          TUNNEL_REMOTE_PORT_COLUMN = 11
          TUNNEL_AUTO_START_COLUMN  = 12


          # rubocop:disable Metrics/MethodLength
          def create_hosts_treeview_model(hosts)
            model = Gtk::TreeStore.new(String, String, String, String, String, String, String, String, String, String, String, String, String)

            hosts.each do |host|
              iter = model.append(nil)

              iter[HOST_STATE_COLUMN]         = host.started? ? 'gtk-yes' : 'gtk-no'
              iter[HOST_UUID_COLUMN]          = host.uuid
              iter[HOST_NAME_COLUMN]          = host.name
              iter[HOST_USER_COLUMN]          = host.user
              iter[HOST_HOST_COLUMN]          = host.host
              iter[HOST_PORT_COLUMN]          = host.port
              iter[TUNNEL_NAME_COLUMN]        = ''
              iter[TUNNEL_TYPE_COLUMN]        = ''
              iter[TUNNEL_LOCAL_HOST_COLUMN]  = ''
              iter[TUNNEL_LOCAL_PORT_COLUMN]  = ''
              iter[TUNNEL_REMOTE_HOST_COLUMN] = ''
              iter[TUNNEL_REMOTE_PORT_COLUMN] = ''
              iter[TUNNEL_AUTO_START_COLUMN]  = ''

              tunnels = host.tunnels

              # add children
              tunnels.each do |tunnel|
                child_iter = model.append(iter)

                child_iter[TUNNEL_NAME_COLUMN]        = tunnel.name
                child_iter[TUNNEL_TYPE_COLUMN]        = tunnel.type
                child_iter[TUNNEL_LOCAL_HOST_COLUMN]  = tunnel.local_host
                child_iter[TUNNEL_LOCAL_PORT_COLUMN]  = tunnel.local_port
                child_iter[TUNNEL_REMOTE_HOST_COLUMN] = tunnel.remote_host
                child_iter[TUNNEL_REMOTE_PORT_COLUMN] = tunnel.remote_port
                child_iter[TUNNEL_AUTO_START_COLUMN]  = tunnel.auto_start?.to_s
              end
            end

            model
          end
          # rubocop:enable Metrics/MethodLength


          def create_hosts_treeview(model)
            treeview = Gtk::TreeView.new(model)

            # configure treeview selection
            # sub-rows are not clickable
            treeview.selection.mode = :single
            treeview.selection.set_select_function do |_selection, _model, path, _path_currentry_selected|
              path.to_s.include?(':') ? false : true
            end

            # Disable buttons if tunnels are running
            hosts_treeview_bind_single_click(treeview)

            # Start host tunnels on double-click
            hosts_treeview_bind_double_click(treeview)

            # Popup the menu on right click
            hosts_treeview_bind_right_click(treeview)

            # add columns to the tree view
            hosts_treeview_add_columns(treeview)

            treeview
          end


          def hosts_treeview_bind_single_click(treeview)
            treeview.selection.signal_connect :changed do
              with_host_model do |object|
                disable_buttons_if_tunnels_running(object)
              end
            end
          end


          def hosts_treeview_bind_double_click(treeview)
            treeview.signal_connect :row_activated do |_widget, path|
              if path.to_s.include?(':')
                false
              else
                with_host_model do |object|
                  object.toggle_tunnels!
                  reload_hosts_treeview
                end
              end
            end
          end


          # rubocop:disable Style/SoleNestedConditional
          def hosts_treeview_bind_right_click(treeview)
            treeview.signal_connect :button_press_event do |widget, event|
              if event.is_a?(Gdk::EventButton) && event.button == 3
                if widget.selection.selected && !widget.selection.selected.path.to_s.include?(':')
                  # TODO: finish implementation of right click
                  puts 'RIGHT CLICK'
                end
              end
            end
          end
          # rubocop:enable Style/SoleNestedConditional


          def hosts_treeview_add_columns(treeview)
            add_image_column treeview,  t('view.host.state'),         'icon-name': HOST_STATE_COLUMN
            add_text_column  treeview,  t('view.host.uuid'),          text: HOST_UUID_COLUMN, visible: false
            add_text_column  treeview,  t('view.host.name'),          text: HOST_NAME_COLUMN
            add_text_column  treeview,  t('view.host.user'),          text: HOST_USER_COLUMN
            add_text_column  treeview,  t('view.host.host'),          text: HOST_HOST_COLUMN
            add_text_column  treeview,  t('view.host.port'),          text: HOST_PORT_COLUMN
            add_text_column  treeview,  t('view.tunnel.name'),        text: TUNNEL_NAME_COLUMN
            add_text_column  treeview,  t('view.tunnel.type'),        text: TUNNEL_TYPE_COLUMN
            add_text_column  treeview,  t('view.tunnel.local_host'),  text: TUNNEL_LOCAL_HOST_COLUMN
            add_text_column  treeview,  t('view.tunnel.local_port'),  text: TUNNEL_LOCAL_PORT_COLUMN
            add_text_column  treeview,  t('view.tunnel.remote_host'), text: TUNNEL_REMOTE_HOST_COLUMN
            add_text_column  treeview,  t('view.tunnel.remote_port'), text: TUNNEL_REMOTE_PORT_COLUMN
            add_text_column  treeview,  t('view.tunnel.auto_start'),  text: TUNNEL_AUTO_START_COLUMN
          end


          def all_hosts
            @application.config.hosts
          end


          def find_host_model
            return nil if @hosts_treeview.selection.selected.blank?

            uuid = @hosts_treeview.selection.selected.get_value(HOST_UUID_COLUMN)
            all_hosts.find { |h| h.uuid == uuid }
          end


          def with_host_model
            object = find_host_model
            yield object if object
          end


          def with_new_host_model
            yield SSHTunnel::UI::Models::Host.new
          end


          def disable_buttons_if_tunnels_running(host)
            if host.started?
              button_edit.sensitive   = false
              button_remove.sensitive = false
              button_start.sensitive  = false
              button_stop.sensitive   = true
            else
              button_edit.sensitive   = true
              button_remove.sensitive = true
              button_start.sensitive  = true
              button_stop.sensitive   = false
            end
          end

      end
    end
  end
end
