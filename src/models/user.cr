class User < Granite::Base
  adapter pg
  table_name users

  primary id : Int64
  field password : String
  field email : String
  field nickname : String
  timestamps
end
