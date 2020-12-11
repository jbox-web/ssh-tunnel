# frozen_string_literal: true

module SSHTunnel
  module UI
    module Windows
      class AboutWindow < Gtk::AboutDialog

        # Register the class in the GLib world
        type_register

        class << self

          def init
            # Set the template from the resources binary
            set_template resource: '/com/jbox-web/ssh-tunnel/ui/about_window.glade'
          end

        end

        include SSHTunnel::UI::Helpers::Common::TranslationHelper


        def initialize(application)
          super application: application

          set_title t('window.about')
        end

      end
    end
  end
end
