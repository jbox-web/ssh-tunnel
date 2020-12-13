# frozen_string_literal: true

module SSHTunnel
  module UI
    module Windows
      module Tunnels
        class DeleteWindow < Gtk::Window

          # Register the class in the GLib world
          type_register

          class << self

            def init
              # Set the template from the resources binary
              set_template resource: '/com/jbox-web/ssh-tunnel/ui/tunnels/delete_window.glade'

              bind_template_child 'button_submit'
              bind_template_child 'button_cancel'
            end

          end

          include SSHTunnel::UI::Helpers::Common::ModalHelper
          include SSHTunnel::UI::Helpers::Common::TranslationHelper


          def initialize(application, window, tunnel)
            super

            # Set window title
            set_title t('window.tunnel.remove', tunnel: tunnel.name)

            # Set instance variables
            @tunnel = tunnel
            @host   = tunnel.parent
          end


          private


            def bind_submit_button
              button_submit.label = t('button.submit')
              button_submit.signal_connect :clicked do
                @host.remove_tunnel(@tunnel)
                @application.config.save!
                @window.reload_tunnels_treeview(@host)
                close
              end
            end

        end
      end
    end
  end
end
