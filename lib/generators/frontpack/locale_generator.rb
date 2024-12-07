# frozen_string_literal: true

module Frontpack
  class LocaleGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __dir__)

    def install
      copy_file 'locale/frontpack.en_US.yml', 'config/locale/frontpack.en_US.yml'
    end
  end
end
