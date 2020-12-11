# frozen_string_literal: true

module SSHTunnel
  module UI
    module Helpers
      module Common
        module ModalHelper

          def initialize(application, window, *)
            super application: application

            # Set instance variables
            @application = application
            @window      = window

            # Bind listeners
            bind_submit_button
            bind_cancel_button
          end


          private

            def bind_cancel_button
              # Not all modals have a cancel button
              if respond_to?(:button_cancel)
                button_cancel.label = t('button.cancel')
                button_cancel.signal_connect :clicked do
                  close
                end
              end

              # Bind escape key stroke
              signal_connect :key_press_event do |_widget, event|
                event.keyval == 65_307 ? close : false
              end
            end

        end
      end
    end
  end
end
