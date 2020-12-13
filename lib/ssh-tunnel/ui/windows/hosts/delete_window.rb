# frozen_string_literal: true

module SSHTunnel
  module UI
    module Windows
      module Hosts
        class DeleteWindow < Gtk::Window

          # Register the class in the GLib world
          type_register

          class << self

            def init
              # Set the template from the resources binary
              set_template resource: '/com/jbox-web/ssh-tunnel/ui/hosts/delete_window.glade'

              bind_template_child 'button_submit'
              bind_template_child 'button_cancel'
            end

          end

          include SSHTunnel::UI::Helpers::Common::ModalHelper
          include SSHTunnel::UI::Helpers::Common::TranslationHelper


          def initialize(application, window, host)
            super

            # Set window title
            set_title t('window.host.remove', host: host)

            # Set instance variables
            @host = host
          end


          private


            def bind_submit_button
              button_submit.label = t('button.submit')
              button_submit.signal_connect :clicked do
                @application.config.remove_host(@host)
                @application.config.save!
                @window.reload_hosts_treeview
                close
              end
            end

        end
      end
    end
  end
end
