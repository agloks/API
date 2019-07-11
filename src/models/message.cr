class Message < Granite::Base
  adapter pg
  table_name messages

  primary id : Int64
  field content : String
  timestamps

  belongs_to :lobby, foreign_key: lobby_id : Int32
  belongs_to :user, foreign_key: user_id : Int32
end
