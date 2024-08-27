# frozen_string_literal: true

module SSHTunnel
  module UI
    module Helpers
      module Common
        module TranslationHelper
          extend ActiveSupport::Concern

          def t(...)
            I18n.t(...)
          end

        end
      end
    end
  end
end
