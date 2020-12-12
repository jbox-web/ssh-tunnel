# frozen_string_literal: true

module SSHTunnel
  module UI
    module Forms
      class ApplicationForm

        include ActiveModel::Model
        include ActiveModel::Validations::Callbacks

        class_attribute :attributes

        attr_reader :model

        class << self

          def attribute(name, opts = {})
            self.attributes ||= []
            create_attribute(name, opts)
            self.attributes += [name]
          end

          # rubocop:disable Layout/EmptyLinesAroundAttributeAccessor
          private def create_attribute(name, opts = {})
            required = opts.fetch(:required, false)
            attr_accessor name
            validates_presence_of(name) if required
          end
          # rubocop:enable Layout/EmptyLinesAroundAttributeAccessor

        end


        def initialize(model)
          @model = model
        end


        def submit(params)
          self.class.attributes.each do |attr|
            if params[attr]
              method = "#{attr}="
              __send__(method, params[attr])
            end
          end
        end


        def save
          self.class.attributes.each do |attr|
            value  = __send__(attr)
            method = "#{attr}="
            model.__send__(method, value)
          end
          model
        end


        private


          def cast_to_int(value)
            Integer(value) rescue value
          end

      end
    end
  end
end
