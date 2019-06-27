module Pipes
  class Auth < Amber::Pipe::Base
    def call(context)
      return call_next(context) if context.request.method == "OPTIONS"
      begin
        token = context.request.headers["JWT"]
        data = ::Auth::JWTService.new.decode(token)
      rescue JWT::VerificationError
        return not_auth(context)
      rescue KeyError
        return missing_JWT(context)
      end

      context.session[:current_user_id] = data[0]["user_id"]
      call_next(context)
    end

    private def not_auth(context)
      context.response.status_code = 403
      error = {errors: ["Please Sign In"]}.to_json
      context.response.print error
    end

    private def missing_JWT(context)
      context.response.status_code = 403
      error = {errors: ["Missing JWT headers"]}.to_json
      context.response.print error
    end
  end
end
