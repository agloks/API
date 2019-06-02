require "monads"

module Factory
  class Media
    def initialize(@params : Hash(String, String | Nil), @file_params : Amber::Router::File)
    end

    def build
      unless ::Media::ALLOWED_KINDS.includes?(@params["kind"])
        return Monads::Left.new([{"kind" => "Unknown media kind"}])
      end

      file = @file_params.file
      filename = @file_params.filename || "file"
      headers = { "Content-Type" => @file_params.headers["Content-Type"] }

      @params["file_url"] = BucketService::FileUploader.new(file, filename, headers).upload
      Monads::Right.new(::Media.new(@params))
    end
  end
end
