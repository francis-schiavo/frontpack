# frozen_string_literal: true

require 'importmap-rails'

module Frontpack
  class Engine < ::Rails::Engine
    isolate_namespace Frontpack

    initializer 'frontpack.importmap', before: 'importmap' do |app|
      app.config.importmap.paths << root.join('config/importmap.rb')
      app.config.importmap.cache_sweepers << root.join('app/assets/javascripts')
    end

    initializer 'frontpack.assets' do |app|
      app.config.assets.precompile += %w[frontpack_manifest]
    end

    initializer 'frontpack.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper Frontpack::ApplicationHelper
      end
    end

    initializer 'frontpack.active_record' do
      ActiveRecord::Base.include Frontpack::ExtendedModelTranslations
    end
  end
end
