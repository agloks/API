require "awscr-s3"

module BucketService
  class FileUploader
    FILE_PREFIX = {
      "image/png"  => "picture",
      "image/jpeg" => "picture",
      "video/mp4"  => "video",
      "video/mpeg" => "video",
      "audio/mpeg" => "music",
    }

    def initialize(@file : File, @filename : String, @metadata : Hash(String, String))
      @uploaded_at = ""
      @client = Awscr::S3::Client.new(ENV["AWS_REGION"], ENV["AWS_ACCESS_KEY"], ENV["AWS_SECRET_KEY"])
    end

    def upload
      return Monads::Left.new([{"file" => "Unhandled type file"}]) unless file_type

      @uploaded_at = Time.now.to_s("%F-%k-%M-%S")
      @client.put_object(ENV["AWS_BUCKET"], bucket_filename, @file, @metadata)

      Monads::Right.new({file_url, file_type.not_nil!})
    end

    private def bucket_filename
      "#{file_type}/#{@uploaded_at}-#{@filename}"
    end

    private def file_url
      "https://#{ENV["AWS_BUCKET"]}.s3-#{ENV["AWS_REGION"]}.amazonaws.com/#{bucket_filename}"
    end

    private def file_type
      FILE_PREFIX[@metadata["Content-Type"]]?
    end
  end
end
