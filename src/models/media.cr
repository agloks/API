class Media < Granite::Base
  adapter pg
  table_name medias

  primary id : Int64
  field title : String
  field kind : String
  timestamps

  belongs_to :theme, foreign_key: theme_id : Int32

  SCOPE = {"picture" => Picture}

  def self.pictures
    Picture.where(kind: "picture")
  end

  def specific
    SCOPE[kind].new(self)
  end
end
