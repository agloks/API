class User < Granite::Base
  adapter pg
  table_name users

  primary id : Int64
  field password : String
  field email : String
  field nickname : String
  timestamps

  validate(:email, "Email already in use", ->(user : self) {
    User.all("WHERE email = ? AND id != ?", [user.email, user.id]).empty?
  })

  validate(:nickname, "Nickname already in use", ->(user : self) {
    User.all("WHERE nickname = ? AND id != ?", [user.nickname, user.id]).empty?
  })
end
