# frozen_string_literal: true

module Frontpack
  # Custom input builders
  class FormBuilder < ActionView::Helpers::FormBuilder
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::UrlHelper

    def enum_field(method, options = {})
      excluded_keys = options.key?(:except) ? options[:except] : []

      if @object
        opts = { selected: @object.send(method) }
        select method, @object.enum_options(method, excluded_keys), opts, options
      elsif options.key?(:model)
        model = options[:model]
        select method, model.enum_options(method, excluded_keys), options.slice(:selected, :include_blank, :prompt), options
      else
        select method, [], opts, options
      end
    end

    def autocomplete_field(method, options = {})
      relation = @object.class.reflect_on_association(method)
      uri = relation.class_name.underscore.sub('::', '/')
      display_field = relation.klass.autocomplete_display_fields[1]
      text_field(relation.foreign_key, options.merge('data-url': "/autocomplete/#{uri}", is: 'auto-complete', 'display-value': @object.send(method)&.send(display_field)))
    end

    def text_field(method, options = {})
      set_options(method, options) if @object
      super(method, options)
    end

    def password_field(method, options = {})
      set_options(method, options) if @object
      super
    end

    def email_field(method, options = {})
      set_options(method, options) if @object
      super
    end

    def text_area(method, options = {})
      set_options(method, options) if @object
      super
    end

    def label(method, text = nil, options = {}, &)
      set_label_options method, options if @object
      super(method, text, options, &)
    end

    def select(method, choices = nil, options = {}, html_options = {}, &)
      set_options(method, html_options, css_class: Frontpack::FormBuilderOptions.select_class) if @object
      super
    end

    def number_field(method, options = {})
      set_options(method, options) if @object

      super(method, options)
    end

    def date_field(method, options = {}, _html_options = {})
      @template.text_field(@object_name, method, objectify_options(options.merge(type: :date)))
    end

    def switch_field(method, options = {})
      @template.content_tag(:div, class: 'switch-toggle') do
        toggle_box = check_box(method, { checked: @object.send(method) }.merge(options))
        opts = options.merge(for: "#{@object_name}_#{method}")
        opts[:style] = "--on-icon: '#{options[:'data-on-icon']}';" if options.key? :'data-on-icon'
        opts[:style] += "--off-icon: '#{options[:'data-off-icon']}';" if options.key? :'data-off-icon'
        toggle_box + @template.content_tag(:label, nil, opts)
      end
    end

    private

    def set_options(method, options, css_class: Frontpack::FormBuilderOptions.input_class)
      @object.class.validators.map do |validator|
        next unless validator.attributes.include?(method)

        option_required(options) if validator.is_a? ::ActiveRecord::Validations::PresenceValidator
        options[:maxlength] = validator.options[:maximum] if validator.is_a? ActiveRecord::Validations::LengthValidator
        options[:size] = nil
        set_numericality_options(validator, options) if validator.is_a? ActiveModel::Validations::NumericalityValidator
      end
      merge_css_classes(options, css_class)
    end

    def merge_css_classes(options, css_class)
      classes = []
      classes += options[:class].to_s.split if options.key? :class
      classes << css_class
      options[:class] = classes.join ' '
    end

    # @param [Hash] options
    def option_required(options)
      if options.key?(:required) && options[:required] == false
        options.delete(:required)
        return options
      end

      options[:required] = true
    end

    def set_numericality_options(validator, options)
      if (gt = validator.options[:greater_than])
        options[:min] = gt
      end
      if (lt = validator.options[:less_than])
        options[:max] = lt
      end
      options[:step] = :any
    end

    def set_label_options(method, options)
      @object.class.validators.map do |validator|
        next unless validator.attributes.include?(method)

        options[:'data-required'] = true if validator.is_a?(ActiveRecord::Validations::PresenceValidator)
      end
      merge_css_classes options, Frontpack::FormBuilderOptions.label_class
    end
  end
end
