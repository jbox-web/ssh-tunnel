# frozen_string_literal: true

module SSHTunnel
  module UI
    module Helpers
      module Common
        module TranslationHelper
          extend ActiveSupport::Concern

          ruby2_keywords def t(*args)
            I18n.t(*args)
          end

        end
      end
    end
  end
end
