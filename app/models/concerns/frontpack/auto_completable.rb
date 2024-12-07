module Frontpack
  module AutoCompletable
    extend ActiveSupport::Concern

    included do
      cattr_reader :autocomplete_keyword, :autocomplete_fields
      @autocomplete_display_fields = []
      @autocomplete_key = :id
    end

    class_methods do
      def autocomplete_by(keyword, *extra_filters)
        @autocomplete_keyword = keyword.to_sym
        @autocomplete_fields = extra_filters.map(&:to_sym)
      end

      def autocomplete_with(key, *display_fields)
        @autocomplete_key = key.to_sym
        @autocomplete_display_fields = display_fields.map(&:to_sym)
      end

      def autocomplete(keyword, **params)
        keyword_field = arel_table[@autocomplete_keyword]
        condition = Arel::Nodes::SqlLiteral.new("'%#{keyword}%'")
        query = where(keyword_field.matches(condition))
        params.each { |key, value| query = query.where(arel_table[key].eq(value)) }
        query.select(autocomplete_display_fields).pluck(autocomplete_display_fields)
      end

      def autocomplete_display_fields
        [@autocomplete_key, *@autocomplete_display_fields]
      end
    end
  end
end
