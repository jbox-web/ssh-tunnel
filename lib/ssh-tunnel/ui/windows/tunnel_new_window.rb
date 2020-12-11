# frozen_string_literal: true

module SSHTunnel
  module UI
    module Windows
      class TunnelNewWindow < Gtk::Window

        # Register the class in the GLib world
        type_register

        class << self

          def init
            # Set the template from the resources binary
            set_template resource: '/com/jbox-web/ssh-tunnel/ui/tunnel_new_window.glade'
            super
          end

        end

        include SSHTunnel::UI::Helpers::TunnelWindowHelper


        def initialize(application, window, tunnel)
          super

          # Set window title
          set_title _('New Tunnel')
        end


        private


          # rubocop:disable Metrics/MethodLength, Layout/CommentIndentation
          def bind_submit_button
            button_submit.signal_connect :clicked do
              @tunnel.name        = input_name.text
              @tunnel.type        = input_type.active_id
              @tunnel.local_host  = input_local_host.text
              @tunnel.local_port  = input_local_port.text
              @tunnel.remote_host = input_remote_host.text
              @tunnel.remote_port = input_remote_port.text

              if @tunnel.valid?
                @host.add_tunnel(@tunnel)
                @application.config.save!
                close
                @window.reload_tunnels_treeview(@host)
              else
                # TODO: find a way to render errors
                puts @tunnel.errors
                @tunnel.errors.clear
              end
            end
          end
          # rubocop:enable Metrics/MethodLength, Layout/CommentIndentation

      end
    end
  end
end
