# frozen_string_literal: true

module SSHTunnel
  module UI
    module Forms
      class TunnelForm < ApplicationForm

        attribute :name,        required: true
        attribute :type,        required: true
        attribute :local_host,  required: true
        attribute :local_port,  required: true
        attribute :remote_host, required: true
        attribute :remote_port, required: true
        attribute :auto_start

        validates_inclusion_of :local_port,  in: 0..65_535
        validates_inclusion_of :remote_port, in: 0..65_535

        # Callbacks
        before_validation :cast_port_to_int


        def cast_port_to_int
          self.local_port  = cast_to_int(local_port)
          self.remote_port = cast_to_int(remote_port)
        end

      end
    end
  end
end
