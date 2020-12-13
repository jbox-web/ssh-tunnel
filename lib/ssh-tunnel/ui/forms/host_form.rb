# frozen_string_literal: true

module SSHTunnel
  module UI
    module Forms
      class HostForm < ApplicationForm

        attribute :name, required: true
        attribute :user, required: true
        attribute :host, required: true
        attribute :port, required: true
        attribute :identity_file

        validates_inclusion_of :port, in: 0..65_535

        # Callbacks
        before_validation :cast_port_to_int


        def cast_port_to_int
          self.port = cast_to_int(port)
        end

      end
    end
  end
end
