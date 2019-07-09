module Pipes
  class CORS < Amber::Pipe::Base
    def call(context)
      if context.request.method == "OPTIONS" &&
          !context.request.headers["Access-Control-Request-Headers"].includes? "content-type"
        context.request.headers["Access-Control-Request-Headers"] += ",content-type"
      end
      
      call_next(context)
    end
  end
end
