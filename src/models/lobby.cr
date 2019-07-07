class Lobby < Granite::Base
  adapter pg
  table_name lobbies

  primary id : Int64
  field restricted : Bool
  field active : Bool
  field questions : Int32
  timestamps

  belongs_to :theme, foreign_key: theme_id : Int32
  belongs_to :user, foreign_key: created_by : Int32
end
