module Query
  class Friendships
    def initialize(@user_id : String)
    end

    def all
      exec(select_friendships)
    end

    def pending
      exec(select_friendships("pending"))
    end

    def sent
      exec(select_friendships("sent"))
    end

    def accepted
      exec(select_friendships("accepted"))
    end

    def already_asked?(id)
      Friendship.scalar asked_query(id), &.to_s.to_i > 0
    end

    private def exec(select_query)
      res = Friendship.query(select_query) { |d| d }
      data = Array(Hash(String, String | Nil)).new
      res.each do
        data << {
          "user_id" => res.read(Int64 | Nil).to_s, "friendship_id" => res.read(Int64 | Nil).to_s,
          "nickname" => res.read(String | Nil), "status" => res.read(String | Nil),
        }
      end

      data
    end

    private def select_friendships(status = "all")
      select_query(where_statment(status)) + select_status(status)
    end

    private def select_query(statment)
      "SELECT users.id, friendships.id, users.nickname, friendships.status, \
        friendships.created_at, friendships.updated_at \
        FROM friendships \
        LEFT JOIN users \
        ON (friendships.asked_to = users.id OR friendships.asked_by = users.id) \
        WHERE #{statment} \
        AND users.id != #{@user_id}"
    end

    private def where_statment(request)
      return "friendships.asked_to = #{@user_id}" if request == "pending"
      return "friendships.asked_by = #{@user_id}" if request == "sent"

      "(friendships.asked_to = #{@user_id} OR friendships.asked_by = #{@user_id})"
    end

    private def select_status(status)
      status = "pending" if status == "sent"
      status == "all" ? "" : " AND friendships.status = '#{status}'"
    end

    private def asked_query(id)
      "SELECT COUNT(*) FROM friendships \
        WHERE friendships.status != 'rejected' \
        AND ((friendships.asked_by = #{@user_id} AND friendships.asked_to = #{id}) \
        OR (friendships.asked_by = #{id} AND friendships.asked_to = #{@user_id}))"
    end
  end
end
