# frozen_string_literal: true

module SSHTunnel
  module UI
    module Helpers
      module TunnelWindowHelper

        include SSHTunnel::UI::Helpers::Common::ModalHelper
        include SSHTunnel::UI::Helpers::Common::TranslationHelper


        def self.included(base)
          base.extend(ClassMethods)
          base.extend(SSHTunnel::UI::Helpers::Common::FormHelper)
        end


        module ClassMethods

          FORM_BUTTONS = %w[submit cancel].freeze
          FORM_FIELDS  = %w[name type local_host local_port remote_host remote_port].freeze

          def init
            bind_buttons(FORM_BUTTONS)
            bind_form_fields(FORM_FIELDS)
          end

        end


        def initialize(application, window, tunnel)
          super

          # Set instance variables
          @tunnel = tunnel
          @host   = tunnel.parent

          # Bind listeners
          set_input_labels

          # Load tunnels combobox
          load_tunnels_combobox
        end


        private


          def set_input_labels
            label_name.text        = t('form.tunnel.name')
            label_type.text        = t('form.tunnel.type')
            label_local_host.text  = t('form.tunnel.local_host')
            label_local_port.text  = t('form.tunnel.local_port')
            label_remote_host.text = t('form.tunnel.remote_host')
            label_remote_port.text = t('form.tunnel.remote_port')
          end


          def load_tunnels_combobox
            input_type.append('local', t('form.tunnel.local'))
            input_type.append('remote', t('form.tunnel.remote'))
          end

      end
    end
  end
end
