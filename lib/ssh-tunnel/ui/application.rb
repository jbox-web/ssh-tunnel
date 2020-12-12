# frozen_string_literal: true

module SSHTunnel
  module UI
    class Application < Gtk::Application

      attr_reader :config


      # rubocop:disable Metrics/MethodLength
      def initialize
        super 'com.jbox-web.ssh-tunnel', Gio::ApplicationFlags::FLAGS_NONE

        @config = SSHTunnel.config

        signal_connect :startup do |application|
          quit_accels = ['<Ctrl>Q']

          action = Gio::SimpleAction.new('quit')
          action.signal_connect :activate do |_action, _parameter|
            application.quit
          end

          application.add_action(action)
          application.set_accels_for_action('app.quit', quit_accels)
        end

        signal_connect :activate do |application|
          window = SSHTunnel::UI::Windows::ApplicationWindow.new(application)
          window.present

          # Gtk::StatusIcon is deprecated
          # See: https://developer.gnome.org/gtk3/stable/GtkStatusIcon.html#gtk-status-icon-new
          # SSHTunnel::UI::StatusIcon.new(application, window)
        end
      end
      # rubocop:enable Metrics/MethodLength


      def quit
        @config.hosts.map(&:stop_tunnels!)
        super
      end

    end
  end
end
