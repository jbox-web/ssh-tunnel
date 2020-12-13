# frozen_string_literal: true

module SSHTunnel
  module UI
    module Helpers
      module Common
        module FormHelper
          module ClassMethods

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

          module InstanceMethods

            def params
              params = {}
              form_fields.each do |field_name, method|
                input = "input_#{field_name}"
                field = __send__(input)
                value = field.__send__(method)
                params[field_name] = value
              end
              params
            end


            def bind_submit_button
              button_submit.label = t('button.submit')
              button_submit.signal_connect :clicked do
                submit_form(params)
              end
            end


            def submit_form(params)
              form = form_object
              form.submit(params)
              if form.valid?
                form.save
                save_and_reload_view
              else
                render_form_errors(form.errors)
              end
            end


            def form_object
              raise NotImplementedError
            end


            def save_and_reload_view
              raise NotImplementedError
            end


            def render_form_errors(errors)
              form_fields.each do |field_name, _method|
                has_errors = errors.of_kind?(field_name, :blank) || errors.of_kind?(field_name, :inclusion)
                input = "input_#{field_name}"
                field = __send__(input)
                color = has_errors ? red : white
                field.override_background_color(:normal, color)
              end
            end


            def red
              Gdk::RGBA.new(255, 0, 0)
            end


            def white
              Gdk::RGBA.new(255, 255, 255)
            end


            def restore_form_values(model)
              form_fields.each do |field_name, method|
                input  = "input_#{field_name}"
                field  = __send__(input)
                method = "#{method}="
                value  = model.__send__(field_name)
                if field_name == :identity_file && value.nil?
                  field.unselect_all
                else
                  field.__send__(method, value)
                end
              end
            end


            def set_input_labels(scope:)
              form_fields.each do |field_name, _method|
                label  = "label_#{field_name}"
                field  = __send__(label)
                value  = t("form.#{scope}.#{field_name}")
                field.text = value
              end
            end

          end
        end
      end
    end
  end
end
