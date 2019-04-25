require "monads"
require "crypto/bcrypt/password"

module Auth
  class UserFactory
    def initialize
    end

    def build(params) : Monads::Maybe(User)
      return Monads::Nothing(User).new if params["password"] != params["password_confirmation"]
      params["password"] = Crypto::Bcrypt::Password.create(params["password"].not_nil!, cost: 10).to_s
      Monads::Just.new(User.new(params))
    end
  end
end
