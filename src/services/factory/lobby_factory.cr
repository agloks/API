require "monads"

module Factory
  class Lobby
    def initialize(@params : Hash(String, String | Nil), @user_id : String | Nil)
    end

    def build
      theme = ::Theme.find(@params["theme_id"])
      return Monads::Left.new([{"theme" => "Unknown Theme"}]) if theme.nil?

      medias = ::Media.all("JOIN questions ON medias.id = questions.media_id \
        WHERE medias.theme_id = ? AND questions.answers <> ''", [theme.id])
      if medias.size < @params["questions"].not_nil!.to_i
        return Monads::Left.new([{"questions" => "Nombre de questions maximum possible pour ce thème : #{medias.size}"}])
      end

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
