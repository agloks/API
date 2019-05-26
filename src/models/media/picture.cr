class Picture < Granite::Base
  adapter pg
  table_name medias

  primary id : Int64
  field title : String
  field kind : String
  timestamps

  belongs_to :theme, foreign_key: theme_id : Int32

  def initialize(media : Media)
    self.id = media.id
    self.title = media.title
    self.updated_at = media.updated_at
    self.created_at = media.created_at
    self.theme_id = media.theme_id
    self.kind = "picture"
  end

  def initialize
  end
end
