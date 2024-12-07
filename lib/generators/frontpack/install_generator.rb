# frozen_string_literal: true

module Frontpack
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __dir__)

    def patch_app_base_classes
      inject_into_class 'app/controllers/application_controller.rb', ApplicationController, <<-RUBY
  # Frontpack form builder
  default_form_builder Frontpack::FormBuilder
      RUBY
      copy_file 'initializers/customize_form_with_errors.rb', 'config/initializers/customize_form_with_errors.rb'
    end

    def add_frontpack_assets
      prepend_file 'app/assets/stylesheets/application.scss', <<~SCSS
        @use 'frontpack/frontpack' with (
          $theme-mode: 'dark',
          $background: #2c0408,
          $highlight: #dcac0b,
        );

      SCSS
    end

    def copy_layout
      copy_file 'views/layouts/_form-errors.html.slim', 'app/views/layouts/_form-errors.html.slim'
      copy_file 'views/layouts/_navigation.html.slim', 'app/views/layouts/_navigation.html.slim'
      copy_file 'views/layouts/errors.html.slim', 'app/views/layouts/errors.html.slim'
      template 'views/layouts/application.html.slim', 'app/views/layouts/application.html.slim'
    end

    def copy_locale
      copy_file 'locales/frontpack.en.yml', 'config/locales/frontpack.en.yml'
    end
  end
end
