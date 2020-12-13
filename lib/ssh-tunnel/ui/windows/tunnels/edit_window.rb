# frozen_string_literal: true

module SSHTunnel
  module UI
    module Windows
      module Tunnels
        class EditWindow < Gtk::Window

          # Register the class in the GLib world
          type_register

          class << self

            def init
              # Set the template from the resources binary
              set_template resource: '/com/jbox-web/ssh-tunnel/ui/tunnels/edit_window.glade'
              super
            end

          end

          include SSHTunnel::UI::Helpers::TunnelWindowHelper


          def initialize(application, window, tunnel)
            super

            # Set window title
            set_title t('window.tunnel.edit', tunnel: @tunnel.name)

            # Fills input fields
            restore_form_values(@tunnel)
          end

        end
      end
    end
  end
end
