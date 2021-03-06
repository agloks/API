class User < Granite::Base
  adapter pg
  table_name users

  primary id : Int64
  field password : String
  field email : String
  field nickname : String
  field status : String
  field rank : String
  field chat_socket : String
  timestamps

  belongs_to :lobby, foreign_key: lobby_id : Int32

  before_create :default_values

  validate(:email, "Email already in use", ->(user : self) {
    Validation::Uniqueness.new(user, "email", [""]).valid?
  })

  validate(:nickname, "Nickname already in use", ->(user : self) {
    Validation::Uniqueness.new(user, "nickname", ["Profil supprimé"]).valid?
  })

  validate(:status, "Status should be either 'online', 'offline' or 'afk'", ->(user : self) {
    (user.new_record? && user.status == nil) || %w(online offline afk deleted).includes? user.status
  })

  validate(:rank, "Rank should be either 'user' or 'admin'", ->(user : self) {
    (user.new_record? && user.rank == nil) || %w(admin user).includes? user.rank
  })

  def default_values
    @rank = "user" if rank == nil
    @status = "online" if status == nil
  end

  def admin?
    rank == "admin"
  end
end
