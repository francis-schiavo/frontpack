module Frontpack
  module ExtendedModelTranslations
    extend ActiveSupport::Concern
    include ActiveModel::Naming

    class_methods do
      def human_enum_value(enum_name, enum_value)
        I18n.t("#{i18n_scope}.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
      end

      def enum_options(enum_name, excluded_keys = [])
        keys = send(enum_name.to_s.pluralize).keys.reject { |item| excluded_keys.include? item.to_sym }
        keys.collect { |item| [human_enum_value(enum_name, item), item] }
      end
    end

    delegate :human_attribute_name, to: :class

    def enum_options(enum_name, excluded_keys = [])
      self.class.enum_options(enum_name, excluded_keys)
    end

    def human_enum_name(enum_name)
      self.human_enum_name(enum_name)
    end

    def human_enum_value(enum_name)
      self.class.human_enum_value(enum_name, self[enum_name])
    end
  end
end
