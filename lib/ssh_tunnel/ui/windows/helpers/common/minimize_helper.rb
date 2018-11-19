# frozen_string_literal: true

module SSHTunnel
  module UI
    module Helpers
      module Common
        module MinimizeHelper

          def initialize(*)
            super

            # Set instance variables
            @minimized = false
          end


          def minimized?
            @minimized
          end


          def minimize!
            @minimized = true
            hide
          end


          def maximize!
            @minimized = false
            show
          end


          def toggle!
            if minimized?
              maximize!
            else
              minimize!
            end
          end

        end
      end
    end
  end
end
