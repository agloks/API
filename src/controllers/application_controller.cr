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
end
