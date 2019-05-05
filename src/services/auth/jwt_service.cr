require "jwt"

module Auth
  class JWTService
    def initialize(@algorithm = "HS256", @secret_key = "7QNl8ieiaHwq")
    end

    def encode(payload)
      JWT.encode(payload, @secret_key, @algorithm)
    end

    def decode(token : String)
      JWT.decode(token, @secret_key, @algorithm)
    end
  end
end
