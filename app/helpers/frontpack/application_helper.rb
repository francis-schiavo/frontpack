module Frontpack
  module ApplicationHelper
    def boolean_emoji(boolean)
      boolean ? '✅' : '❌'
    end
  end
end
