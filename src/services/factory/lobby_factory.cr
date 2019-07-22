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
      if lobby.media_duration.nil?
        lobby.media_duration = 35
      elsif !(25..35).includes? lobby.media_duration!
        return Monads::Left.new([{"media_duration" => "Media duration must be between 25 and 35"}])
      end
      Monads::Right.new(lobby)
    end
  end
end
