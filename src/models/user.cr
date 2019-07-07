class User < Granite::Base
  adapter pg
  table_name users

  primary id : Int64
  field password : String
  field email : String
  field nickname : String
  field status : String
  field rank : String
  timestamps

  before_create :default_values

  validate(:email, "Email already in use", ->(user : self) {
    Validation::Uniqueness.new(user, "email").valid?
  })

  validate(:nickname, "Nickname already in use", ->(user : self) {
    Validation::Uniqueness.new(user, "nickname").valid?
  })

  validate(:status, "Status should be either 'online', 'offline' or 'afk'", ->(user : self) {
    (user.new_record? && user.status == nil) || %w(online offline afk).includes? user.status
  })

  validate(:rank, "Rank should be either 'user' or 'admin'", ->(user : self) {
    (user.new_record? && user.rank == nil) || %w(admin user).includes? user.status
  })

  def default_values
    @rank = "user" if rank == nil
    @status = "online" if status == nil
  end
end
