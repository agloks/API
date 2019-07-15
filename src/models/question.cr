class Question < Granite::Base
  adapter pg
  table_name questions

  belongs_to :media, foreign_key: media_id : Int32

  primary id : Int64
  field content : String
  field answers : String
  timestamps
end
