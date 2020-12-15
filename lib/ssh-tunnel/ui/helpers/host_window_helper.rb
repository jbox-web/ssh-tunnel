# frozen_string_literal: true

module SSHTunnel
  module UI
    module Helpers
      module HostWindowHelper

        include SSHTunnel::UI::Helpers::Common::ModalHelper
        include SSHTunnel::UI::Helpers::Common::TranslationHelper
        include SSHTunnel::UI::Helpers::Common::TreeViewHelper
        include SSHTunnel::UI::Helpers::Common::FormHelper::InstanceMethods

        def self.included(base)
          base.extend(ClassMethods)
          base.extend(SSHTunnel::UI::Helpers::Common::FormHelper::ClassMethods)
        end

        FORM_BUTTONS = %w[submit cancel add edit remove reset_identity_file].freeze
        FORM_FIELDS  = {
          name: {
            type: :text,
          },
          user: {
            type: :text,
          },
          host: {
            type: :text,
          },
          port: {
            type: :text,
          },
          identity_file: {
            type: :file,
          },
        }.freeze


        module ClassMethods

          def init
            bind_buttons(FORM_BUTTONS)
            bind_form_fields(FORM_FIELDS.keys)
            bind_template_child 'tunnels_scrolled_window'
          end

        end


        def initialize(application, window, host)
          super

          # Set instance variables
          @host = host

          # Bind listeners
          set_input_labels(scope: :host)
          bind_host_buttons
          bind_tunnels_buttons

          # Load tunnels treeview
          load_tunnels_treeview(@host)
        end


        def load_tunnels_treeview(host)
          # create treeview
          treeview_model    = create_tunnels_treeview_model(host.tunnels)
          @tunnels_treeview = create_tunnels_treeview(treeview_model)

          # Render treeview
          tunnels_scrolled_window.add(@tunnels_treeview)
          @tunnels_treeview.show
        end


        def reload_tunnels_treeview(host)
          @tunnels_treeview.destroy
          load_tunnels_treeview(host)
        end


        private


          TUNNEL_UUID_COLUMN        = 0
          TUNNEL_NAME_COLUMN        = 1
          TUNNEL_TYPE_COLUMN        = 2
          TUNNEL_LOCAL_HOST_COLUMN  = 3
          TUNNEL_LOCAL_PORT_COLUMN  = 4
          TUNNEL_REMOTE_HOST_COLUMN = 5
          TUNNEL_REMOTE_PORT_COLUMN = 6
          TUNNEL_AUTO_START_COLUMN  = 7


          def create_tunnels_treeview_model(tunnels)
            model = Gtk::ListStore.new(String, String, String, String, String, String, String, String)

            tunnels.each do |tunnel|
              iter = model.append
              iter.set_values([tunnel.uuid, tunnel.name, tunnel.type, tunnel.local_host, tunnel.local_port, tunnel.remote_host, tunnel.remote_port, tunnel.auto_start?.to_s])
            end

            model
          end


          def create_tunnels_treeview(model)
            treeview = Gtk::TreeView.new(model)

            # edit tunnel on double-click
            tunnels_treeview_bind_double_click(treeview)

            # add columns to the tree view
            tunnels_treeview_add_columns(treeview)

            treeview
          end


          def tunnels_treeview_bind_double_click(treeview)
            treeview.signal_connect :row_activated do |_widget, path|
              if path.to_s.include?(':')
                false
              else
                with_tunnel_model do |object|
                  window = SSHTunnel::UI::Windows::Tunnels::EditWindow.new(application, self, object)
                  window.present
                end
              end
            end
          end


          def tunnels_treeview_add_columns(treeview)
            add_text_column treeview, t('view.tunnel.uuid'),        text: TUNNEL_UUID_COLUMN, visible: false
            add_text_column treeview, t('view.tunnel.name'),        text: TUNNEL_NAME_COLUMN
            add_text_column treeview, t('view.tunnel.type'),        text: TUNNEL_TYPE_COLUMN
            add_text_column treeview, t('view.tunnel.local_host'),  text: TUNNEL_LOCAL_HOST_COLUMN
            add_text_column treeview, t('view.tunnel.local_port'),  text: TUNNEL_LOCAL_PORT_COLUMN
            add_text_column treeview, t('view.tunnel.remote_host'), text: TUNNEL_REMOTE_HOST_COLUMN
            add_text_column treeview, t('view.tunnel.remote_port'), text: TUNNEL_REMOTE_PORT_COLUMN
            add_text_column treeview, t('view.tunnel.auto_start'),  text: TUNNEL_AUTO_START_COLUMN
          end


          def bind_host_buttons
            button_reset_identity_file.label = t('button.reset')
            button_reset_identity_file.tooltip_text = t('tooltip.host.reset_identity_file')
            button_reset_identity_file.signal_connect :clicked do
              input_identity_file.unselect_all
            end
          end


          # rubocop:disable Metrics/MethodLength
          def bind_tunnels_buttons
            button_add.label = t('button.add')
            button_add.tooltip_text = t('tooltip.tunnel.add')
            button_add.signal_connect :clicked do
              with_new_tunnel_model do |object|
                window = SSHTunnel::UI::Windows::Tunnels::NewWindow.new(application, self, object)
                window.present
              end
            end

            button_edit.label = t('button.edit')
            button_edit.tooltip_text = t('tooltip.tunnel.edit')
            button_edit.signal_connect :clicked do
              with_tunnel_model do |object|
                window = SSHTunnel::UI::Windows::Tunnels::EditWindow.new(application, self, object)
                window.present
              end
            end

            button_remove.label = t('button.remove')
            button_remove.tooltip_text = t('tooltip.tunnel.remove')
            button_remove.signal_connect :clicked do
              with_tunnel_model do |object|
                window = SSHTunnel::UI::Windows::Tunnels::DeleteWindow.new(application, self, object)
                window.present
              end
            end
          end
          # rubocop:enable Metrics/MethodLength


          def all_tunnels
            @host.tunnels
          end


          def find_tunnel_model
            return nil if @tunnels_treeview.selection.selected.blank?

            uuid = @tunnels_treeview.selection.selected.get_value(TUNNEL_UUID_COLUMN)
            all_tunnels.find { |t| t.uuid == uuid }
          end


          def with_tunnel_model
            object = find_tunnel_model
            yield object if object
          end


          def with_new_tunnel_model
            yield SSHTunnel::UI::Models::Tunnel.new(parent: @host)
          end


          def form_fields
            FORM_FIELDS
          end


          def form_object
            SSHTunnel::UI::Forms::HostForm.new(@host)
          end


          def save_and_reload_view
            @application.config.save!
            close
            @window.reload_hosts_treeview
          end

      end
    end
  end
end
