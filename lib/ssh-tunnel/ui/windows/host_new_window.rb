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


          # rubocop:disable Metrics/MethodLength, Layout/CommentIndentation
          def bind_submit_button
            button_submit.label = t('button.submit')
            button_submit.signal_connect :clicked do
              @host.name = input_name.text
              @host.user = input_user.text
              @host.host = input_host.text
              @host.port = input_port.text

              if @host.valid?
                @application.config.add_host(@host)
                @application.config.save!
                close
                @window.reload_hosts_treeview
              else
                # TODO: find a way to render errors
                puts @host.errors
                @host.errors.clear
              end
            end
          end
          # rubocop:enable Metrics/MethodLength, Layout/CommentIndentation

      end
    end
  end
end
