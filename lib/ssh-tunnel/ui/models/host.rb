# frozen_string_literal: true

module SSHTunnel
  module UI
    module Models
      class Host

        attr_accessor :name, :user, :host, :port
        attr_reader   :tunnels, :errors


        def initialize(opts = {})
          @name    = opts.fetch(:name, '')
          @user    = opts[:user]
          @host    = opts[:host]
          @port    = opts[:port]
          @tunnels = opts.fetch(:tunnels, []).map { |t_attr| Tunnel.new(t_attr.merge(parent: self)) }
          @started = false
          @errors  = []
        end


        def to_s
          name
        end


        def add_tunnel(tunnel)
          @tunnels << tunnel
        end


        def remove_tunnel(tunnel)
          @tunnels.delete(tunnel)
        end


        def valid?
          validate_presence_of(:name)
          validate_presence_of(:user)
          validate_presence_of(:host)
          validate_presence_of(:port)

          errors.empty?
        end


        def to_hash
          {
            name:    name,
            user:    user,
            host:    host,
            port:    port,
            tunnels: tunnels.map(&:to_hash),
          }
        end


        def started?
          @started
        end


        def start_tunnels!
          tunnels.map(&:start!)
          @started = true
        end


        def stop_tunnels!
          tunnels.map(&:stop!)
          @started = false
        end


        def toggle_tunnels!
          if started?
            stop_tunnels!
          else
            start_tunnels!
          end
        end


        private


          def validate_presence_of(field)
            return true if send(field).present?

            @errors << "#{field} is empty"
            false
          end

      end
    end
  end
end