# frozen_string_literal: true

module SSHTunnel
  module UI
    module Helpers
      module Common
        module TranslationHelper
          extend ActiveSupport::Concern

          included do
            include GetText
            bindtextdomain 'com.jbox-web.ssh-tunnel', path: SSHTunnel.locales_path.to_s
          end

        end
      end
    end
  end
end
