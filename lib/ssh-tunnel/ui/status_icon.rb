# frozen_string_literal: true

module SSHTunnel
  module UI
    class StatusIcon

      def initialize(application, window)
        @application = application
        @window      = window
        @status_icon = Gtk::StatusIcon.new
        @menu        = Gtk::Menu.new

        configure_status_icon
        create_popup_menu
      end


      private


        def configure_status_icon
          @status_icon.icon_name = 'network-workgroup-symbolic'
          @status_icon.signal_connect('activate') { |_icon| @window.toggle! }
          @status_icon.signal_connect('popup-menu') { |_tray, button, time| @menu.popup(nil, nil, button, time) }
        end


        def create_popup_menu
          # Build menu items
          info = Gtk::ImageMenuItem.new(label: 'Modifier')
          info.signal_connect('activate') { @window.show }

          quit = Gtk::ImageMenuItem.new(label: 'Quitter')
          quit.signal_connect('activate') { @application.quit }

          # Create menu
          @menu.append(info)
          @menu.append(Gtk::SeparatorMenuItem.new)
          @menu.append(quit)
          @menu.show_all
        end

    end
  end
end
