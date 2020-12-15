# frozen_string_literal: true

module SSHTunnel
  module UI
    module Models
      class Tunnel

        attr_accessor :uuid, :name, :parent, :type, :local_host, :local_port, :remote_host, :remote_port, :auto_start


        def initialize(opts = {})
          @uuid        = opts.fetch(:uuid) { SecureRandom.uuid }
          @name        = opts.fetch(:name, '')
          @parent      = opts[:parent]
          @type        = opts[:type]
          @local_host  = opts[:local_host]
          @local_port  = opts[:local_port]
          @remote_host = opts[:remote_host]
          @remote_port = opts[:remote_port]
          @auto_start  = opts[:auto_start]
          @process     = nil
          @started     = false
        end


        def to_s
          "#{parent} - #{name}"
        end


        def local_port
          @local_port.to_s
        end


        def remote_port
          @remote_port.to_s
        end


        def to_hash
          {
            uuid:        uuid,
            name:        name,
            type:        type,
            local_host:  local_host,
            local_port:  @local_port,
            remote_host: remote_host,
            remote_port: @remote_port,
            auto_start:  auto_start,
          }
        end


        def auto_start?
          @auto_start == true
        end


        def auto_start!
          return false unless auto_start?

          start!
          true
        end


        def started?
          @started
        end


        def start!
          return if started?

          SSHTunnel.logger.info "Starting tunnel : #{self}"

          @process = Subprocess.popen(command, stdout: '/dev/null', stderr: '/dev/null', stdin: Subprocess::PIPE)
          @started = true
        end


        # See: https://www.redhat.com/archives/libvir-list/2007-September/msg00106.html
        # to avoid zombie when terminating process
        def stop!
          return unless started?
          return if @process.nil?

          SSHTunnel.logger.info "Stopping tunnel : #{self}"

          @process.terminate
          @process.wait
          @started = false
          @process = nil
        end


        def command
          cmd = [
            '/usr/bin/ssh',
            '-N',
            '-t',
            '-x',
            '-o', 'ExitOnForwardFailure=yes',
            "-l#{parent.user}",
            "-L#{local_host}:#{local_port}:#{remote_host}:#{remote_port}",
            "-p#{parent.port}"
          ]

          cmd << "-i#{parent.identity_file}" if parent.identity_file.present?
          cmd << parent.host
          cmd
        end

      end
    end
  end
end
