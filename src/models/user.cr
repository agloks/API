class User < Granite::Base
  adapter pg
  table_name users

  primary id : Int64
  field password : String
  field email : String
  field nickname : String
  timestamps

  validate(:email, "Email already in use", ->(user : self) {
    User.find_by(email: user.email).nil?
  })

  validate(:nickname, "Nickname already in use", ->(user : self) {
    User.find_by(nickname: user.nickname).nil?
  })
end
