class Score < Granite::Base
  adapter pg
  table_name scores

  primary id : Int64
  field points : Int32
  timestamps

  belongs_to :question, foreign_key: question_id : Int32
  belongs_to :user, foreign_key: user_id : Int32
  belongs_to :game, foreign_key: game_id : Int32
end
