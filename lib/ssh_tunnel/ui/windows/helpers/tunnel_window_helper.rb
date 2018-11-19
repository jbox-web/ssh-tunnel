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
            label_name.text        = _('Name')
            label_type.text        = _('Type')
            label_local_host.text  = _('Local Host')
            label_local_port.text  = _('Local Port')
            label_remote_host.text = _('Remote Host')
            label_remote_port.text = _('Remote Port')
          end


          def load_tunnels_combobox
            input_type.append('local', _('Local'))
            input_type.append('remote', _('Remote'))
          end

      end
    end
  end
end
