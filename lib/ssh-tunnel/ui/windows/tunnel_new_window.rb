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
          set_title t('window.tunnel.new')
        end


        private


          def save_and_reload_view
            @host.add_tunnel(@tunnel)
            super
          end

      end
    end
  end
end
