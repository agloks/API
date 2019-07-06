require "monads"

module Factory
  class Friendship
    def initialize(@params : Hash(String, String | Nil), @current_user : String)
    end

    def build
      return Monads::Left.new([{"friendship" => "Friendship already asked"}]) if already_asked?
      return Monads::Left.new([{"friendship" => "You can't be your own friend"}]) if @current_user == @params["asked_to"]

      friendship = ::Friendship.new @params
      friendship.asked_by = @current_user.to_i
      friendship.status = "pending"
      Monads::Right.new(friendship)
    end

    private def already_asked?
      Query::Friendships.new(@current_user).already_asked?(@params["asked_to"].not_nil!)
    end
  end
end
