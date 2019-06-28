require "jasper_helpers"

class ApplicationController < Amber::Controller::Base
  include JasperHelpers
  LAYOUT = "application.slang"

  def handle_error
    ->(errors : Array(Hash(String, String))) do
      respond_with(403) do
        json({errors: errors}.to_json)
      end
    end
  end

  private def formatted_errors(model)
    model.errors.map { |error| {error.field.to_s => error.message.to_s} }
  end
end
