class Friendship < Granite::Base
  adapter pg
  table_name friendships

  primary id : Int64
  field status : String
  field asked_by : Int32
  field asked_to : Int32
  timestamps

  validate(:status, "Status should be either 'pending', 'accepted' or 'rejected'", ->(friendship : self) {
    %w(pending accepted rejected).includes? friendship.status
  })
end
