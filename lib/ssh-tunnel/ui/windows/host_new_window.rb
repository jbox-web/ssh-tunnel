# frozen_string_literal: true

module SSHTunnel
  module UI
    module Windows
      class HostNewWindow < Gtk::Window

        # Register the class in the GLib world
        type_register

        class << self

          def init
            # Set the template from the resources binary
            set_template resource: '/com/jbox-web/ssh-tunnel/ui/host_new_window.glade'
            super
          end

        end

        include SSHTunnel::UI::Helpers::HostWindowHelper


        def initialize(application, window, host)
          super

          # Set window title
          set_title t('window.host.new')
        end


        private


          def save_and_reload_view
            @application.config.add_host(@host)
            super
          end

      end
    end
  end
end
