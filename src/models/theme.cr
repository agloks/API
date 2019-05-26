class Theme < Granite::Base
  adapter pg
  table_name themes

  primary id : Int64
  field title : String
  field description : String
  timestamps

  belongs_to :user, foreign_key: user_id : Int32
  has_many :medias
end
