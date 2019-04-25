module Pipes
  class Auth < Amber::Pipe::Base
    def call(context)
      begin
        token = context.request.headers["JWT"]
        data = ::Auth::JWTService.new.decode(token)
      rescue JWT::VerificationError
        return not_auth(context)
      end

      return not_auth(context) if context.session[:current_user_id] != data[0]["user_id"].to_s

      call_next(context)
    end

    private def not_auth(context)
      context.response.status_code = 404
      error = { error: "Please Sign In" }.to_json
      context.response.print error
    end
  end
end
