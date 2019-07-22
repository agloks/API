require "monads"
require "crypto/bcrypt/password"

module Factory
  class User
    def initialize(@params : Hash(String, String | Nil))
    end

    def build
      return Monads::Left.new([{"password" => "Passwords don't match"}]) unless same_passwords?
      return Monads::Left.new([{"password" => "Password is too short"}]) if (@params["password"] || "").size < 8
      return Monads::Left.new([{"nickname" => "Nickname is not valable"}]) if @params["nickname"] == "Profil supprimé"
      @params["password"] = Crypto::Bcrypt::Password.create(@params["password"].not_nil!, cost: 10).to_s
      Monads::Right.new(::User.new(@params))
    end

    private def same_passwords?
      @params["password"] == @params["password_confirmation"]
    end
  end
end
