# frozen_string_literal: true

module SSHTunnel
  module UI
    module Helpers
      module Common
        module FormHelper

          def bind_menu_entries(entries)
            entries.each do |f|
              bind_template_child "menu_#{f}"
            end
          end


          def bind_buttons(buttons)
            buttons.each do |f|
              bind_template_child "button_#{f}"
            end
          end


          def bind_form_fields(fields)
            fields.each do |f|
              bind_template_child "label_#{f}"
              bind_template_child "input_#{f}"
            end
          end

        end
      end
    end
  end
end
