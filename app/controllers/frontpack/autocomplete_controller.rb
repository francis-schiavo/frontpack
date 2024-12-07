module Frontpack
  # Autocomplete controller
  class AutocompleteController < ApplicationController
    before_action :set_model

    def show
      query = @model.autocomplete(params[:keyword], **autocomplete_params)
      data = query.map do |row|
        if row.is_a? String
          { id: row, value: row }
        else
          {
            id: row.shift,
            value: row.join(' ')
          }
        end
      end
      respond_to do |format|
        format.json { render json: data }
      end
    end

    private

    def set_model
      @model = params[:model].split('/').map(&:classify).join('::').constantize
    end

    def autocomplete_params
      params.permit(*@model.autocomplete_fields)
    end
  end
end
