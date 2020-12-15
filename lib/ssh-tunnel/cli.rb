# frozen_string_literal: true

module SSHTunnel
  class CLI
    include Singleton

    def parse(args = ARGV)
      setup_options(args)
      validate!
      load_config!
    end


    def run
      compile_resources!
      load_resources!
      set_locales!
      boot_application!
    end


    private


      def setup_options(args)
        @opts = parse_options(args)
      end


      def parse_options(argv)
        opts = {}
        @parser = option_parser(opts)
        @parser.parse!(argv)
        opts
      end


      def option_parser(opts)
        parser = OptionParser.new do |o|
          o.on '-C', '--config PATH', 'path to YAML config file' do |arg|
            opts[:config_file] = arg
          end
        end

        parser.banner = 'ssh-tunnel [options]'
        parser.on_tail '-h', '--help', 'Show help' do
          puts parser
          exit 1
        end

        parser
      end


      def validate!
        if @opts[:config_file]
          raise ArgumentError, "No such file #{@opts[:config_file]}" unless File.exist?(@opts[:config_file])
        else
          @opts[:config_file] = Pathname.new(File.expand_path('~/.config/ssh-tunnel/config.json'))
        end
      end


      def load_config!
        SSHTunnel.load_config(@opts[:config_file])
      end


      def compile_resources!
        cmd = [
          'glib-compile-resources',
          '--target',    SSHTunnel.resources_bin.to_s,
          '--sourcedir', SSHTunnel.resources_path.to_s,
          SSHTunnel.resources_xml.to_s
        ]
        system(*cmd)
      end


      def load_resources!
        resources = Gio::Resource.load(SSHTunnel.resources_bin.to_s)
        Gio::Resources.register(resources)
      end


      def set_locales!
        I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
        I18n.load_path << Dir[SSHTunnel.locales_path]

        I18n.enforce_available_locales = false
        I18n.available_locales         = %i[en fr]
        I18n.default_locale            = SSHTunnel.current_locale
        I18n.fallbacks                 = [:en]
      end


      def boot_application!
        SSHTunnel.config.hosts.each(&:auto_start!)
        app = SSHTunnel::UI::Application.new

        begin
          status = app.run
        rescue Interrupt => e
          status = 0
        ensure
          SSHTunnel.config.hosts.each(&:stop_tunnels!)
        end

        status
      end

  end
end
