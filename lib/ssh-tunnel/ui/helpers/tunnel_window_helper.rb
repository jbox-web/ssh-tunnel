# frozen_string_literal: true

module SSHTunnel
  module UI
    module Helpers
      module TunnelWindowHelper

        include SSHTunnel::UI::Helpers::Common::ModalHelper
        include SSHTunnel::UI::Helpers::Common::TranslationHelper
        include SSHTunnel::UI::Helpers::Common::FormHelper::InstanceMethods

        def self.included(base)
          base.extend(ClassMethods)
          base.extend(SSHTunnel::UI::Helpers::Common::FormHelper::ClassMethods)
        end

        FORM_BUTTONS = %i[submit cancel].freeze
        FORM_FIELDS  = {
          name: {
            type: :text,
          },
          type: {
            type: :select,
          },
          local_host: {
            type: :text,
          },
          local_port: {
            type: :text,
          },
          remote_host: {
            type: :text,
          },
          remote_port: {
            type: :text,
          },
          auto_start: {
            type: :checkbox,
          },
        }.freeze


        module ClassMethods

          def init
            bind_buttons(FORM_BUTTONS)
            bind_form_fields(FORM_FIELDS.keys)
          end

        end


        def initialize(application, window, tunnel)
          super

          # Set instance variables
          @tunnel = tunnel
          @host   = tunnel.parent

          # Bind listeners
          set_input_labels(scope: :tunnel)

          # Load tunnels combobox
          load_tunnels_combobox
        end


        private


          def load_tunnels_combobox
            input_type.append('local', t('form.tunnel.local'))
            input_type.append('remote', t('form.tunnel.remote'))
          end


          def form_fields
            FORM_FIELDS
          end


          def form_object
            SSHTunnel::UI::Forms::TunnelForm.new(@tunnel)
          end


          def save_and_reload_view
            @application.config.save!
            close
            @window.reload_tunnels_treeview(@host)
          end

      end
    end
  end
end
