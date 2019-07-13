module Pipes
  class CORS < Amber::Pipe::CORS
    def call(context)
      if android?(context.request)
        call_next(context)
      else
        if preflight?(context) && !content_type?(context.request)
          context.request.headers[Amber::Pipe::Headers::REQUEST_HEADERS] += ",content-type"
        end
        super
      end
    end

    private def android?(request) : Bool
      request.headers["source"]? == "android"
    end

    private def content_type?(request) : Bool
      request.headers[Amber::Pipe::Headers::REQUEST_HEADERS].includes? "content-type"
    end
  end
end
