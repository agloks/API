require "monads"

module Factory
  class Media
    def initialize(@params : Hash(String, String | Nil))
    end

    def build
      return Monads::Left.new([{"kind" => "Unknown media kind"}]) unless ::Media::SCOPE.keys.includes?(@params["kind"])
      Monads::Right.new(::Media.new(@params).specific)
    end
  end
end
