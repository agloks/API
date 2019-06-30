class User < Granite::Base
  adapter pg
  table_name users

  primary id : Int64
  field password : String
  field email : String
  field nickname : String
  timestamps

  validate(:email, "Email already in use", ->(user : self) {
    Validation::Uniqueness.new(user, "email").valid?
  })

  validate(:nickname, "Nickname already in use", ->(user : self) {
    Validation::Uniqueness.new(user, "nickname").valid?
  })
end
