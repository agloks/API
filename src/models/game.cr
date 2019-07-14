class Game < Granite::Base
  adapter pg
  table_name games

  primary id : Int64
  timestamps

  belongs_to :lobby, foreign_key: lobby_id : Int32
end
