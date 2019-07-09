require "monads"

module Factory
  class Lobby
    def initialize(@params : Hash(String, String | Nil), @user_id : String | Nil)
    end

    def build
      lobby = ::Lobby.new(@params)
      lobby.created_by = @user_id.try(&.to_i)
      lobby.private_key = Random::Secure.hex(6) if lobby.restricted
      lobby.active = true
      Monads::Right.new(lobby)
    end
  end
end
