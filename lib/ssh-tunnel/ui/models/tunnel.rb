# frozen_string_literal: true

module SSHTunnel
  module UI
    module Models
      class Tunnel

        attr_accessor :name, :parent, :type, :local_host, :local_port, :remote_host, :remote_port


        def initialize(opts = {})
          @name        = opts.fetch(:name, '')
          @parent      = opts[:parent]
          @type        = opts[:type]
          @local_host  = opts[:local_host]
          @local_port  = opts[:local_port]
          @remote_host = opts[:remote_host]
          @remote_port = opts[:remote_port]
          @process     = nil
          @started     = false
        end


        def to_s
          "#{parent} - #{name}"
        end


        def to_hash
          {
            name:        name,
            type:        type,
            local_host:  local_host,
            local_port:  local_port,
            remote_host: remote_host,
            remote_port: remote_port,
          }
        end


        def started?
          @started
        end


        def start!
          return if started?

          @process = Subprocess.popen(command, stdout: '/dev/null', stderr: '/dev/null', stdin: Subprocess::PIPE)
          @started = true
        end


        # See: https://www.redhat.com/archives/libvir-list/2007-September/msg00106.html
        # to avoid zombie when terminating process
        def stop!
          return unless started?
          return if @process.nil?

          @process.terminate
          @process.wait
          @started = false
          @process = nil
        end


        def command
          [
            '/usr/bin/ssh',
            '-N',
            '-t',
            '-x',
            '-o', 'ExitOnForwardFailure=yes',
            "-l#{parent.user}",
            "-L#{local_host}:#{local_port}:#{remote_host}:#{remote_port}",
            "-p#{parent.port}",
            parent.host
          ]
        end

      end
    end
  end
end
