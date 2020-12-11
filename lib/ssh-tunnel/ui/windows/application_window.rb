# frozen_string_literal: true

module SSHTunnel
  module UI
    module Windows
      class ApplicationWindow < Gtk::ApplicationWindow

        # Register the class in the GLib world
        type_register

        class << self

          def init
            # Set the template from the resources binary
            set_template resource: '/com/jbox-web/ssh-tunnel/ui/application_window.glade'
            super

            bind_template_child 'hosts_scrolled_window'
          end

        end

        include SSHTunnel::UI::Helpers::ApplicationWindowHelper


        def initialize(application)
          super application: application

          # Set instance variables
          @application = application

          # Set window title
          set_title 'SSH Tunnel Manager'

          # Load hosts treeview
          load_hosts_treeview
        end

      end
    end
  end
end
