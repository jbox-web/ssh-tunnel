# frozen_string_literal: true

module SSHTunnel
  module UI
    module Helpers
      module HostWindowHelper

        include SSHTunnel::UI::Helpers::Common::ModalHelper
        include SSHTunnel::UI::Helpers::Common::TranslationHelper
        include SSHTunnel::UI::Helpers::Common::FormHelper::InstanceMethods

        def self.included(base)
          base.extend(ClassMethods)
          base.extend(SSHTunnel::UI::Helpers::Common::FormHelper::ClassMethods)
        end

        FORM_BUTTONS = %w[submit cancel add edit remove].freeze
        FORM_FIELDS  = {
          name: :text,
          user: :text,
          host: :text,
          port: :text,
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
          set_input_labels
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


          TUNNEL_NAME_COLUMN        = 0
          TUNNEL_TYPE_COLUMN        = 1
          TUNNEL_LOCAL_HOST_COLUMN  = 2
          TUNNEL_LOCAL_PORT_COLUMN  = 3
          TUNNEL_REMOTE_HOST_COLUMN = 4
          TUNNEL_REMOTE_PORT_COLUMN = 5


          def create_tunnels_treeview_model(tunnels)
            model = Gtk::ListStore.new(String, String, String, String, String, String)

            tunnels.each do |tunnel|
              iter = model.append
              iter.set_values([tunnel.name, tunnel.type, tunnel.local_host, tunnel.local_port, tunnel.remote_host, tunnel.remote_port])
            end

            model
          end


          def create_tunnels_treeview(model)
            treeview = Gtk::TreeView.new(model)

            # add columns to the tree view
            tunnels_treeview_add_columns(treeview)

            treeview
          end


          def tunnels_treeview_add_columns(treeview)
            add_text_column(treeview, t('view.host.tunnel_name'), text: TUNNEL_NAME_COLUMN)
            add_text_column(treeview, t('view.host.tunnel_type'), text: TUNNEL_TYPE_COLUMN)
            add_text_column(treeview, t('view.host.local_host'),  text: TUNNEL_LOCAL_HOST_COLUMN)
            add_text_column(treeview, t('view.host.local_port'),  text: TUNNEL_LOCAL_PORT_COLUMN)
            add_text_column(treeview, t('view.host.remote_host'), text: TUNNEL_REMOTE_HOST_COLUMN)
            add_text_column(treeview, t('view.host.remote_port'), text: TUNNEL_REMOTE_PORT_COLUMN)
          end


          def add_text_column(treeview, label, attributes)
            renderer = Gtk::CellRendererText.new
            column   = Gtk::TreeViewColumn.new(label, renderer, attributes)
            treeview.append_column(column)
          end


          def set_input_labels
            label_name.text = t('form.host.name')
            label_user.text = t('form.host.user')
            label_host.text = t('form.host.host')
            label_port.text = t('form.host.port')
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

            index = @tunnels_treeview.selection.selected.path.to_s.to_i
            all_tunnels[index]
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
