class Lobby < Granite::Base
  adapter pg
  table_name lobbies

  primary id : Int64
  field restricted : Bool
  timestamps

  belongs_to :theme, foreign_key: theme_id : Int32
end
