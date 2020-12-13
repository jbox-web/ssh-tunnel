# frozen_string_literal: true

module SSHTunnel
  module UI
    module Models
      class Config

        attr_reader :file, :data, :hosts


        def initialize(file)
          @file = file
          load!
        end


        def load!
          @data  = load_json_file(file)
          @hosts = load_hosts
        end


        def add_host(host)
          @hosts << host
        end


        def remove_host(host)
          @hosts.delete(host)
        end


        def save!
          write_yaml_file(file, to_hash)
        end


        def to_hash
          marshal_dump(hosts: hosts.sort_by(&:name).map(&:to_hash))
        end


        private


          def load_json_file(file)
            return hash_with_indifferent_access unless File.exist?(file)

            content = File.read(file)
            return hash_with_indifferent_access if content.empty?

            hash_with_indifferent_access JSON.parse(content)
          end


          def load_hosts
            (data[:hosts] || []).map do |host_attr|
              SSHTunnel::UI::Models::Host.new(host_attr)
            end.sort_by(&:name)
          end


          def write_yaml_file(file, data)
            File.open(file, 'w+') do |f|
              f.write JSON.pretty_generate(data)
            end
          end


          def hash_with_indifferent_access(hash = {})
            hash.with_indifferent_access
          end


          def marshal_dump(data = {})
            JSON.parse(data.to_json)
          end

      end
    end
  end
end
