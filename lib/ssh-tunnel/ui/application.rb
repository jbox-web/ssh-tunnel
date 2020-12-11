# frozen_string_literal: true

module SSHTunnel
  module UI
    class Application < Gtk::Application

      class << self

        def run!
          create_directories!
          compile_resources!
          load_resources!
          compile_locales!
          load_locales!
          run_application!
        end


        private


          def create_directories!
            return if File.directory?(SSHTunnel.user_data_path) &&
                      File.directory?(SSHTunnel.locales_path.join('fr', 'LC_MESSAGES')) &&
                      File.directory?(SSHTunnel.locales_path.join('en', 'LC_MESSAGES')) &&
                      File.directory?(SSHTunnel.tmp_path)

            FileUtils.mkdir_p SSHTunnel.user_data_path
            FileUtils.mkdir_p SSHTunnel.tmp_path
            FileUtils.mkdir_p SSHTunnel.locales_path.join('fr', 'LC_MESSAGES')
            FileUtils.mkdir_p SSHTunnel.locales_path.join('en', 'LC_MESSAGES')
          end


          def compile_resources!
            cmd = [
              'glib-compile-resources',
              '--target',    SSHTunnel.resources_bin.to_s,
              '--sourcedir', SSHTunnel.resources_path.to_s,
              SSHTunnel.resources_xml.to_s
            ]
            system(*cmd)
          end


          def load_resources!
            resources = Gio::Resource.load(SSHTunnel.resources_bin.to_s)
            Gio::Resources.register(resources)
          end


          def compile_locales!
            system('rmsgfmt', SSHTunnel.resources_path.join('locales', 'fr.po').to_s, '-o', SSHTunnel.locales_path.join('fr', 'LC_MESSAGES', 'com.jbox-web.ssh-tunnel.mo').to_s)
            system('rmsgfmt', SSHTunnel.resources_path.join('locales', 'en.po').to_s, '-o', SSHTunnel.locales_path.join('en', 'LC_MESSAGES', 'com.jbox-web.ssh-tunnel.mo').to_s)
          end


          def load_locales!
            GLib::GetText.bindtextdomain 'com.jbox-web.ssh-tunnel', SSHTunnel.locales_path.to_s
          end


          def run_application!
            app = SSHTunnel::UI::Application.new
            app.run
          end

      end


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

          SSHTunnel::UI::StatusIcon.new(application, window)
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
