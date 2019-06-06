class Media < Granite::Base
  adapter pg
  table_name medias

  primary id : Int64
  field title : String
  field kind : String
  field file_url : String
  timestamps

  belongs_to :theme, foreign_key: theme_id : Int32

  def self.pictures
    Media.where(kind: "picture")
  end

  def self.videos
    Media.where(kind: "video")
  end

  def self.musics
    Media.where(kind: "music")
  end
end
