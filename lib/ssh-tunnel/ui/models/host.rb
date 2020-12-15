# frozen_string_literal: true

module SSHTunnel
  module UI
    module Models
      class Host

        attr_accessor :uuid, :name, :user, :host, :port, :identity_file, :tunnels


        def initialize(opts = {})
          @uuid          = opts.fetch(:uuid) { SecureRandom.uuid }
          @name          = opts.fetch(:name, '')
          @user          = opts[:user]
          @host          = opts[:host]
          @port          = opts[:port]
          @identity_file = opts[:identity_file]
          @tunnels       = opts.fetch(:tunnels, []).map { |t_attr| Tunnel.new(t_attr.merge(parent: self)) }
          @started       = false
        end


        def to_s
          name
        end


        def port
          @port.to_s
        end


        def to_hash
          {
            uuid:          uuid,
            name:          name,
            user:          user,
            host:          host,
            port:          @port,
            identity_file: identity_file,
            tunnels:       tunnels.sort_by(&:name).map(&:to_hash),
          }
        end


        def add_tunnel(tunnel)
          @tunnels << tunnel
        end


        def remove_tunnel(tunnel)
          @tunnels.delete(tunnel)
        end


        def auto_start!
          started = tunnels.map(&:auto_start!)
          @started = started.any?
        end


        def started?
          @started
        end


        def start_tunnels!
          tunnels.each(&:start!)
          @started = true
        end


        def stop_tunnels!
          tunnels.each(&:stop!)
          @started = false
        end


        def toggle_tunnels!
          if started?
            stop_tunnels!
          else
            start_tunnels!
          end
        end

      end
    end
  end
end
